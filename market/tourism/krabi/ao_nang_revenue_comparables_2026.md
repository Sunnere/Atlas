# Ao Nang Revenue Comparables 2026

Status: Evidence Collection
Version: 1.0
Date: 2026-08-08

Purpose:

Document observed property-level accommodation asking rates for
Ao Nang / Krabi.

IMPORTANT:

These are observed booking rates for specific dates and are NOT
equivalent to annual ADR.

They may include temporary promotions, Genius discounts, Getaway
Deals, last-minute discounts or other booking-channel incentives.

Evidence classes:

- VERIFIED = directly observed source data
- DERIVED = calculation from verified data
- ASSUMPTION = internal modelling assumption
- UNKNOWN = not sufficiently verified

---

# 1. Market Benchmark

AirDNA Krabi:

Average occupancy:
47%

Average ADR:
USD 114

RevPAR:
USD 51

Seasonality score:
56 / 100

Active listings:
8,543

Revenue growth YoY:
+21.6%

Occupancy growth YoY:
+7.3%

ADR growth YoY:
+10.5%

Active listing growth:
+24.7%

Source:

AirDNA Krabi Market Data
https://www.airdna.co/vacation-rental-data/app/th/default/krabi/overview

Evidence:

VERIFIED

Interpretation:

This is a market-level benchmark and must not be applied directly
to an individual property.

---

# 2. Property-Level Revenue Observations

## Comparable R01 — Aonang Oscar Pool Villas

Unit:

2-bedroom private pool villa

Observed rate:

CNY 1,343/night

Observed promotion:

28% off

Additional:

10% service charge included

Taxes excluded.

Source:

Booking.com

Evidence:

VERIFIED OBSERVED RATE

---

## Comparable R02 — Aonang Oscar Pool Villas

Unit:

3-bedroom private pool villa

Observed rate:

CNY 1,465/night

Observed promotion:

28% off

Taxes excluded.

Source:

Booking.com

Evidence:

VERIFIED OBSERVED RATE

---

## Comparable R03 — KG Private Pool Villa

Unit:

2-bedroom private pool villa

Observed rate:

CNY 1,264/night

Observed promotion:

10% off

Source:

Booking.com

Evidence:

VERIFIED OBSERVED RATE

---

## Comparable R04 — KG Private Pool Villa

Unit:

3-bedroom private pool villa

Observed rate:

CNY 1,833/night

Observed promotion:

10% off

Source:

Booking.com

Evidence:

VERIFIED OBSERVED RATE

---

## Comparable R05 — Cliff Haven Villa

Unit:

2-bedroom private pool villa

Observed rate:

CNY 918/night

Observed promotion:

55% off

Taxes excluded.

Source:

Booking.com

Evidence:

VERIFIED OBSERVED RATE

---

## Comparable R06 — Arterra Haven

Unit:

2-bedroom private pool villa

Observed rate:

CNY 707/night

Observed promotion:

57% off

Taxes excluded.

Source:

Booking.com

Evidence:

VERIFIED OBSERVED RATE

---

## Comparable R07 — Pakbia Pool Villa Aonang

Unit:

3-bedroom private pool villa

Observed rate:

CNY 1,392/night

Observed promotion:

10% off

Additional charges may apply.

Source:

Booking.com

Evidence:

VERIFIED OBSERVED RATE

---

## Comparable R08 — The Haven Krabi

Unit:

3-bedroom villa with private pool

Observed rate:

USD 151/night

Observed promotion:

41% off

Cleaning fee:

700 THB per stay

Taxes excluded.

Source:

Booking.com

Evidence:

VERIFIED OBSERVED RATE

---

## Comparable R09 — Lark Pool Villa Aonang

Unit:

3-bedroom private pool villa

Observed rate:

CNY 2,042/night

Observed promotion:

39% off

Source:

Booking.com

Evidence:

VERIFIED OBSERVED RATE

---

## Comparable R10 — Andara Ao Nang Pool Villa

Unit:

3-bedroom private pool villa

Observed rate:

CNY 2,231/night

Observed promotion:

57% off

Taxes excluded.

Source:

Booking.com

Evidence:

VERIFIED OBSERVED RATE

---

# 3. Data Quality Warning

The observed Booking.com rates above were displayed for specific
search dates.

They must NOT be treated as:

- annual ADR;
- average realized rate;
- guaranteed achievable rate;
- net owner revenue.

They represent:

OBSERVED ASKING RATE FOR A SPECIFIC BOOKING WINDOW.

---

# 4. Discount Signal

Several observed properties display substantial temporary discounts.

Observed examples:

28%
39%
41%
55%
57%

This demonstrates that published headline rates can materially differ
from the actual rate presented to customers.

Therefore Sunnere's model must distinguish between:

Published ADR

and

Realized ADR.

---

# 5. Revenue Model Variables

Future model must contain:

Published ADR

× discount factor

= Realized ADR

Realized ADR

× occupied nights

= Gross room revenue

Gross room revenue

- booking channel fees
- payment fees
- cleaning
- utilities
- maintenance
- taxes / applicable charges

= Operating revenue contribution

---

# 6. Occupancy

Krabi market-level occupancy:

47%

This is VERIFIED market-level evidence.

It should be used as a benchmark only.

For the Sunnere pilot we should model at least:

Conservative:
35%

Base:
47%

Strong:
60%

Exceptional:
70%

These are modelling scenarios, not forecasts.

---

# 7. Seasonality

AirDNA reports a Krabi seasonality score of:

56 / 100

Interpretation:

Demand has meaningful seasonal variation.

Therefore the financial model should NOT use one constant ADR
and occupancy percentage across all twelve months.

Future model:

High season:
higher ADR + higher occupancy

Shoulder season:
normal ADR + normal occupancy

Low season:
discounted ADR + lower occupancy

---

# 8. Property-Level Revenue Evidence Gap

Still required:

- exact comparable property location;
- exact booking dates;
- standard rate before discount;
- discounted rate;
- length-of-stay requirements;
- occupancy / availability signal;
- review count;
- rating;
- cleaning fee;
- taxes;
- channel fee;
- cancellation conditions;
- repeated observations across multiple dates.

---

# 9. Critical Principle

A property should not be underwritten using:

Market ADR × market occupancy

alone.

The correct process is:

Market benchmark

↓

Property comparable set

↓

Observed pricing

↓

Seasonality

↓

Realized ADR assumption

↓

Occupancy scenario

↓

Gross revenue

↓

Operating costs

↓

Maximum sustainable lease

---

# 10. Current Status

REVENUE EVIDENCE:

PARTIALLY COMPLETE

Market-level evidence:

COMPLETE

Property-level price observations:

INITIAL SET COMPLETE

Property-level annual revenue:

NOT YET VERIFIED

Property-level occupancy:

NOT YET VERIFIED

---

# 11. Next Decision Gate

Before signing a Lease & Operate agreement:

Build a property-specific revenue model using:

- minimum 10 comparable properties;
- multiple booking dates;
- seasonality;
- realistic discount rate;
- realistic occupancy;
- all operating costs.

Only then calculate:

MAXIMUM ACCEPTABLE MONTHLY LEASE

