using { cuid, managed, sap.common.CodeList } from '@sap/cds/common';

namespace com.products;

// ─── Main Entities ─────────────────────────────────────────────────────────────

entity Products : cuid, managed {
  name        : String(100) not null;
  description : String(500);
  price       : Decimal(13,2);
  currency    : Association to Currencies;
  stock       : Integer default 0;
  category    : Association to Categories;
  status      : String(10) enum { active = 'A'; inactive = 'I'; } default 'A';
  imageUrl    : String(255);
  items       : Composition of many OrderItems on items.product = $self;
}

entity Categories : cuid, managed {
  name        : String(100) not null;
  description : String(255);
  products    : Association to many Products on products.category = $self;
}

entity Orders : cuid, managed {
  orderNumber : String(20);
  customer    : String(100);
  orderDate   : DateTime;
  status      : String(20) enum {
    pending    = 'PENDING';
    confirmed  = 'CONFIRMED';
    shipped    = 'SHIPPED';
    delivered  = 'DELIVERED';
    cancelled  = 'CANCELLED';
  } default 'PENDING';
  totalAmount : Decimal(13,2);
  items       : Composition of many OrderItems on items.order = $self;
}

entity OrderItems : cuid {
  order    : Association to Orders;
  product  : Association to Products;
  quantity : Integer not null;
  unitPrice: Decimal(13,2);
  subtotal : Decimal(13,2);
}

// ─── Code Lists ──────────────────────────────────────────────────────────────

entity Currencies : CodeList {
  key code : String(3);
  symbol   : String(5);
}
