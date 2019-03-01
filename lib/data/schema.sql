CREATE TABLE partners(
    id INTEGER UNIQUE,
    name TEXT,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE buyers(
    id INTEGER UNIQUE,
    name TEXT,
    partner_id INTEGER,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE goods(
    id INTEGER UNIQUE,
    name TEXT,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE measures(
    id INTEGER UNIQUE,
    name TEXT,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE goods_barcodes(
    goods_id INTEGER,
    barcode TEXT,
    measure_id INTEGER,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE buyer_goods(
    goods_id INTEGER,
    buyer_id INTEGER,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE return_orders(
    buyer_id INTEGER,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE return_goods(
    return_order_id INTEGER,
    goods_id INTEGER,
    measure_id INTEGER,
    volume DECIMAL,
    production_date DATETIME,
    is_bad INTEGER,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
