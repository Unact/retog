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
    left_volume INTEGER,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE goods_barcodes(
    goods_id INTEGER,
    barcode TEXT,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE return_orders(
    buyer_id INTEGER,
    need_pickup INTEGER,
    type INTEGER,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE return_goods(
    return_order_id INTEGER,
    goods_id INTEGER,
    volume INTEGER,
    production_date DATETIME,
    is_bad INTEGER,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE return_types(
    id INTEGER,
    name TEXT,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
CREATE TABLE partner_return_types(
    partner_id INTEGER,
    return_type_id INTEGER,

    local_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
    local_id INTEGER PRIMARY KEY,
    local_inserted INTEGER DEFAULT 0,
    local_updated INTEGER DEFAULT 0,
    local_deleted INTEGER DEFAULT 0
);
