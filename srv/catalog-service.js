'use strict';

const cds = require('@sap/cds');

module.exports = class CatalogService extends cds.ApplicationService {

  async init() {

    const { Products, Orders, OrderItems } = this.entities;

    // ─── BEFORE Handlers (Validation) ──────────────────────────────────────

    /**
     * Validate product data before create/update
     */
    this.before(['CREATE', 'UPDATE'], Products, async (req) => {
      const { price, stock, name } = req.data;

      if (name && name.trim().length < 3) {
        req.error(400, 'Product name must be at least 3 characters long');
      }
      if (price !== undefined && price < 0) {
        req.error(400, 'Price cannot be negative');
      }
      if (stock !== undefined && stock < 0) {
        req.error(400, 'Stock cannot be negative');
      }
    });

    /**
     * Set order number automatically before create
     */
    this.before('CREATE', Orders, async (req) => {
      if (!req.data.orderNumber) {
        const timestamp = new Date().getTime();
        req.data.orderNumber = `ORD-${timestamp}`;
      }
      req.data.orderDate = new Date().toISOString();
    });

    // ─── ON Handlers (Custom Actions) ────────────────────────────────────────

    /**
     * Custom action: add product to cart / place order
     */
    this.on('addToCart', Products, async (req) => {
      const { quantity } = req.data;
      const productId = req.params[0].ID;

      const product = await SELECT.one.from(Products).where({ ID: productId });
      if (!product) return req.error(404, 'Product not found');
      if (product.stock < quantity) {
        return req.error(400, `Insufficient stock. Available: ${product.stock}`);
      }

      return `Product "${product.name}" added to cart (qty: ${quantity})`;
    });

    /**
     * Custom action: discontinue a product
     */
    this.on('discontinue', Products, async (req) => {
      const productId = req.params[0].ID;
      await UPDATE(Products).set({ status: 'I' }).where({ ID: productId });
      return SELECT.one.from(Products).where({ ID: productId });
    });

    // ─── AFTER Handlers (Post-processing) ────────────────────────────────────

    /**
     * Calculate order total after items are updated
     */
    this.after(['CREATE', 'UPDATE'], OrderItems, async (data, req) => {
      const item = Array.isArray(data) ? data[0] : data;
      if (!item?.order_ID) return;

      // Recalculate subtotal
      await UPDATE(OrderItems)
        .set('subtotal = quantity * unitPrice')
        .where({ ID: item.ID });

      // Recalculate order total
      const [{ total }] = await SELECT
        .from(OrderItems)
        .columns('sum(subtotal) as total')
        .where({ order_ID: item.order_ID });

      await UPDATE(Orders)
        .set({ totalAmount: total || 0 })
        .where({ ID: item.order_ID });
    });

    // ─── READ Handlers (Custom queries) ──────────────────────────────────────

    /**
     * Add virtual field 'stockStatus' to products
     */
    this.after('READ', Products, (products) => {
      const list = Array.isArray(products) ? products : [products];
      list.forEach(p => {
        if (p.stock !== undefined) {
          p.stockStatus = p.stock === 0 ? 'Out of Stock'
            : p.stock < 5    ? 'Low Stock'
            : 'In Stock';
        }
      });
    });

    return super.init();
  }
};
