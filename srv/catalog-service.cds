using com.products as db from '../db/schema';

// ─── Catalog Service (Public API) ────────────────────────────────────────────

service CatalogService @(path: '/catalog') {

  // Products - exposed with read/write access
  @odata.draft.enabled
  entity Products   as projection on db.Products actions {
    action addToCart(quantity: Integer) returns String;
    action discontinue()               returns Products;
  };

  // Categories - read only from this service
  @readonly
  entity Categories as projection on db.Categories;

  // Orders - full CRUD
  @odata.draft.enabled
  entity Orders     as projection on db.Orders;

  entity OrderItems as projection on db.OrderItems;

  // Currencies CodeList
  @readonly
  entity Currencies as projection on db.Currencies;
}

// ─── Annotations for Fiori Elements ─────────────────────────────────────────

annotate CatalogService.Products with @(
  UI: {
    HeaderInfo: {
      TypeName      : 'Product',
      TypeNamePlural: 'Products',
      Title         : { Value: name },
      Description   : { Value: category.name }
    },
    LineItem: [
      { Value: name,             Label: 'Product Name' },
      { Value: category.name,   Label: 'Category'     },
      { Value: price,            Label: 'Price'        },
      { Value: stock,            Label: 'Stock'        },
      {
        $Type : 'UI.DataField',
        Value : status,
        Criticality: status == 'A' ? #Positive : #Negative
      }
    ],
    Facets: [
      {
        $Type : 'UI.ReferenceFacet',
        Label : 'General Info',
        Target: '@UI.FieldGroup#General'
      },
      {
        $Type : 'UI.ReferenceFacet',
        Label : 'Order Items',
        Target: 'items/@UI.LineItem'
      }
    ],
    FieldGroup#General: {
      Data: [
        { Value: name        },
        { Value: description },
        { Value: price       },
        { Value: currency_code },
        { Value: stock       },
        { Value: status      }
      ]
    },
    SelectionFields: [ category_ID, status ]
  }
);

annotate CatalogService.Orders with @(
  UI: {
    HeaderInfo: {
      TypeName      : 'Order',
      TypeNamePlural: 'Orders',
      Title         : { Value: orderNumber },
      Description   : { Value: customer }
    },
    LineItem: [
      { Value: orderNumber  },
      { Value: customer     },
      { Value: orderDate    },
      { Value: status       },
      { Value: totalAmount  }
    ],
    SelectionFields: [ status, orderDate ]
  }
);
