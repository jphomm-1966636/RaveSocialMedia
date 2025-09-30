-- ======================
-- Custom ENUM types
-- ======================
CREATE TYPE listing_status AS ENUM (
  'ACTIVE',
  'SOLD',
  'CANCELED'
);

CREATE TYPE offer_status AS ENUM (
  'PENDING',
  'ACCEPTED',
  'DECLINED',
  'CANCELED',
  'EXPIRED'
);

-- ======================
-- Users
-- ======================
CREATE TABLE app_user (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ======================
-- Events
-- ======================
CREATE TABLE event (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  venue TEXT,
  city TEXT,
  start_time TIMESTAMPTZ NOT NULL,
  tags TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ======================
-- Listings
-- ======================
CREATE TABLE listing (
  id BIGSERIAL PRIMARY KEY,
  seller_id BIGINT NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
  event_id BIGINT NOT NULL REFERENCES event(id) ON DELETE CASCADE,
  ticket_type TEXT NOT NULL,
  quantity INT NOT NULL CHECK (quantity >= 0),
  price_cents BIGINT NOT NULL CHECK (price_cents >= 0),
  transfer_method TEXT,
  status listing_status NOT NULL DEFAULT 'ACTIVE',
  version INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ======================
-- Offers
-- ======================
CREATE TABLE offer (
  id BIGSERIAL PRIMARY KEY,
  listing_id BIGINT NOT NULL REFERENCES listing(id) ON DELETE CASCADE,
  buyer_id BIGINT NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
  amount_cents BIGINT NOT NULL CHECK (amount_cents >= 0),
  quantity INT NOT NULL CHECK (quantity > 0),
  status offer_status NOT NULL DEFAULT 'PENDING',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ======================
-- Indexes
-- ======================
CREATE INDEX idx_event_city_time ON event(city, start_time);
CREATE INDEX idx_listing_event ON listing(event_id);
CREATE INDEX idx_offer_listing ON offer(listing_id);
