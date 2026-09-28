-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Log 1 tables searching
.tables
-- airports
-- atm_transactions
-- bakery_security_logs
-- bank_accounts
-- crime_scene_reports
-- flights
-- interviews
-- passengers
-- people
-- phone_calls

-- Humphrey Street crimes on that day // the duck crime id = 295 at 10.15 am AND interviews with 3 witness
SELECT * FROM crime_scene_reports WHERE day = 28 AND month = 7 AND year = 2025 AND street = 'Humphrey Street';

-- interview search
SELECT * FROM interviews WHERE day = 28 AND month = 7 AND year = 2025;
/*
+---+-------+----+-----+---+----------------------------------------------------------------------------------------------------------------+
|id | name  |year|month|day|                                                   transcript                                                   |
+---+-------+----+-----+---+----------------------------------------------------------------------------------------------------------------+
|158|Jose   |2025|    7| 28|“Ah,” said he, “I forgot that I had not seen you for some weeks. It is a little souvenir from the King of       |
|   |       |    |     |   |Bohemia in return for my assistance in the case of the Irene Adler papers.”                                     |
+---+-------+----+-----+---+----------------------------------------------------------------------------------------------------------------+
|159|Eugene |2025|    7| 28|“I suppose,” said Holmes, “that when Mr. Windibank came back from France he was very annoyed at your having gone|
|   |       |    |     |   |to the ball.”                                                                                                   |
+---+-------+----+-----+---+----------------------------------------------------------------------------------------------------------------+
|160|Barbara|2025|    7| 28|“You had my note?” he asked with a deep harsh voice and a strongly marked German accent. “I told you that I     |
|   |       |    |     |   |would call.” He looked from one to the other of us, as if uncertain which to address.                           |
+---+-------+----+-----+---+----------------------------------------------------------------------------------------------------------------+
|161|Ruth   |2025|    7| 28|Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive    |
|   |       |    |     |   |away. If you have security footage from the bakery parking lot, you might want to look for cars that left the   |
|   |       |    |     |   |parking lot in that time frame.                                                                                 |
+---+-------+----+-----+---+----------------------------------------------------------------------------------------------------------------+
|162|Eugene |2025|    7| 28|I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's|
|   |       |    |     |   |bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.              |
+---+-------+----+-----+---+----------------------------------------------------------------------------------------------------------------+
|163|Raymond|2025|    7| 28|As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call,|
|   |       |    |     |   |I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief |
|   |       |    |     |   |then asked the person on the other end of the phone to purchase the flight ...                                  |
+---+-------+----+-----+---+----------------------------------------------------------------------------------------------------------------+
I see 3 options
1.1 Emma's Bakery parking lot
1.2 Atm ON Legget Street in the morning
1.3 Flight the day after possibly germany
*/

-- 1.1 Bakery parking lot
/*Dead end for now
+-----+------+-------+-----+------+--------+----------+---------------+
| id  | year | month | day | hour | minute | activity | license_plate |
+-----+------+-------+-----+------+--------+----------+---------------+
| 260 | 2025 |     7 |  28 |   10 |     16 | exit     | 5P2BI95       |
| 261 | 2025 |     7 |  28 |   10 |     18 | exit     | 94KL13X       |
| 262 | 2025 |     7 |  28 |   10 |     18 | exit     | 6P58WS2       |
| 263 | 2025 |     7 |  28 |   10 |     19 | exit     | 4328GD8       |
| 264 | 2025 |     7 |  28 |   10 |     20 | exit     | G412CB7       |
| 265 | 2025 |     7 |  28 |   10 |     21 | exit     | L93JTIZ       |
| 266 | 2025 |     7 |  28 |   10 |     23 | exit     | 322W7JE       |
| 267 | 2025 |     7 |  28 |   10 |     23 | exit     | 0NTHK55       |
+-----+------+-------+-----+------+--------+----------+---------------+
*/
SELECT *
  FROM bakery_security_logs
 WHERE day = 28
   AND month = 7
   AND year = 2025
   AND hour = 10
   AND minute < 30
   AND minute > 15;

-- 1.2 ATM ARC
/*
+-----+----------------+------+-------+-----+----------------+------------------+--------+
| id  | account_number | year | month | day |  atm_location  | transaction_type | amount |
+-----+----------------+------+-------+-----+----------------+------------------+--------+
| 246 |       28500762 | 2025 |     7 |  28 | Leggett Street | withdraw         |     48 |
| 264 |       28296815 | 2025 |     7 |  28 | Leggett Street | withdraw         |     20 |
| 266 |       76054385 | 2025 |     7 |  28 | Leggett Street | withdraw         |     60 |
| 267 |       49610011 | 2025 |     7 |  28 | Leggett Street | withdraw         |     50 |
| 269 |       16153065 | 2025 |     7 |  28 | Leggett Street | withdraw         |     80 |
| 288 |       25506511 | 2025 |     7 |  28 | Leggett Street | withdraw         |     20 |
| 313 |       81061156 | 2025 |     7 |  28 | Leggett Street | withdraw         |     30 |
| 336 |       26013199 | 2025 |     7 |  28 | Leggett Street | withdraw         |     35 |
+-----+----------------+------+-------+-----+----------------+------------------+--------+
*/

/*
+---------+
|  name   |
+---------+
| Kenny   |
| Iman    |
| Benista |
| Taylor  |
| Brooke  |
| Luca    |
| Diana   |
| Bruce   |
+---------+
*/
SELECT name FROM people WHERE id IN (
    SELECT person_id FROM bank_accounts WHERE account_number IN (
    SELECT account_number
      FROM atm_transactions
     WHERE day = 28
       AND month = 7
       AND year = 2025
       AND atm_location = 'Leggett Street'
       AND transaction_type = 'withdraw'
  )
);


-- 1.3 FLIGHT
/*
+----+--------------+-----------------------------+------------+
| id | abbreviation |          full_name          |    city    |
+----+--------------+-----------------------------+------------+
|  8 | CSF          | Fiftyville Regional Airport | Fiftyville |
+----+--------------+-----------------------------+------------+
*/
SELECT * FROM airports WHERE city = 'Fiftyville';

SELECT *
  FROM airports
  JOIN flights as f ON airports.id = f.destination_airport_id
 WHERE airports.id IN (
    SELECT destination_airport_id FROM flights
     WHERE origin_airport_id = (
        SELECT id FROM airports WHERE city = 'Fiftyville'
     )
 )
   AND f.day = 29
   AND f.month = 7
   AND f.year = 2025
 ORDER BY f.hour, f.minute
 LIMIT 1;

/*
Traced Flight
+--+------------+-----------------+-------------+--+-----------------+--------------------+----+-----+---+----+------+
|id|abbreviation|    full_name    |    city     |id|origin_airport_id|destination_airpo...|year|month|day|hour|minute|
+--+------------+-----------------+-------------+--+-----------------+--------------------+----+-----+---+----+------+
| 4|LGA         |LaGuardia Airport|New York City|36|                8|                   4|2025|    7| 29|   8|    20|
+--+------------+-----------------+-------------+--+-----------------+--------------------+----+-----+---+----+------+

Tracing the passengers

*/
SELECT * FROM passengers WHERE flight_id = 36;

SELECT *
  FROM flights
 WHERE day = 28f
   AND month = 7
   AND year = 2025;


-- Connecting Bakery AND ATM Transactions

-- atm
SELECT license_plate
  FROM people
 WHERE id IN (
    SELECT person_id FROM bank_accounts WHERE account_number IN (
    SELECT account_number
      FROM atm_transactions
     WHERE day = 28
       AND month = 7
       AND year = 2025
       AND atm_location = 'Leggett Street'
       AND transaction_type = 'withdraw'
  )
)

-- bakery

SELECT license_plate
  FROM bakery_security_logs
 WHERE day = 28
   AND month = 7
   AND year = 2025
   AND hour = 10
   AND minute < 30
   AND minute > 15;

-- finally combining bakery and ATM investigation

SELECT *
  FROM people
 WHERE license_plate IN (
    SELECT license_plate
      FROM people
     WHERE id IN (
        SELECT person_id FROM bank_accounts WHERE account_number IN (
            SELECT account_number
              FROM atm_transactions
             WHERE day = 28
               AND month = 7
               AND year = 2025
               AND atm_location = 'Leggett Street'
               AND transaction_type = 'withdraw'
        )
    )
) AND license_plate IN (
    SELECT license_plate
      FROM bakery_security_logs
     WHERE day = 28
       AND month = 7
       AND year = 2025
       AND hour = 10
       AND minute < 30
       AND minute > 15
);

/*Results
+--------+-------+----------------+-----------------+---------------+
|   id   | name  |  phone_number  | passport_number | license_plate |
+--------+-------+----------------+-----------------+---------------+
| 396669 | Iman  | (829) 555-5269 |      7049073643 | L93JTIZ       |
| 467400 | Luca  | (389) 555-5198 |      8496433585 | 4328GD8       |
| 514354 | Diana | (770) 555-1861 |      3592750733 | 322W7JE       |
| 686048 | Bruce | (367) 555-5533 |      5773159633 | 94KL13X       |
+--------+-------+----------------+-----------------+---------------+
*/

-- Combining these results with airport passport records

-- flight tracing first
SELECT * FROM passengers WHERE flight_id = 36;

-- combining flight with previous combo
SELECT *
  FROM people
 WHERE license_plate IN (
    SELECT license_plate
      FROM people
     WHERE id IN (
        SELECT person_id FROM bank_accounts WHERE account_number IN (
            SELECT account_number
              FROM atm_transactions
             WHERE day = 28
               AND month = 7
               AND year = 2025
               AND atm_location = 'Leggett Street'
               AND transaction_type = 'withdraw'
        )
    )
) AND license_plate IN (
    SELECT license_plate
      FROM bakery_security_logs
     WHERE day = 28
       AND month = 7
       AND year = 2025
       AND hour = 10
       AND minute < 30
       AND minute > 15
) AND passport_number IN (
    SELECT passport_number
      FROM passengers
     WHERE flight_id = 36
);


/*Found 2 People gotta trace their call
+--------+-------+----------------+-----------------+---------------+
|   id   | name  |  phone_number  | passport_number | license_plate |
+--------+-------+----------------+-----------------+---------------+
| 467400 | Luca  | (389) 555-5198 |      8496433585 | 4328GD8       |
| 686048 | Bruce | (367) 555-5533 |      5773159633 | 94KL13X       |
+--------+-------+----------------+-----------------+---------------+
*/

-- Phone call tracing after THIS

-- for caller with less than a minute

SELECT caller, receiver, people.name FROM phone_calls
  JOIN people ON people.phone_number = phone_calls.caller
 WHERE day = 28
   AND month = 7
   AND year = 2025
   AND duration < 60
   AND caller IN (
    SELECT phone_number
  FROM people
 WHERE license_plate IN (
    SELECT license_plate
      FROM people
     WHERE id IN (
        SELECT person_id FROM bank_accounts WHERE account_number IN (
            SELECT account_number
              FROM atm_transactions
             WHERE day = 28
               AND month = 7
               AND year = 2025
               AND atm_location = 'Leggett Street'
               AND transaction_type = 'withdraw'
        )
    )
) AND license_plate IN (
    SELECT license_plate
      FROM bakery_security_logs
     WHERE day = 28
       AND month = 7
       AND year = 2025
       AND hour = 10
       AND minute < 30
       AND minute > 15
) AND passport_number IN (
    SELECT passport_number
      FROM passengers
     WHERE flight_id = 36
)
);

/*
+----------------+-------+
|     caller     | name  |
+----------------+-------+
| (367) 555-5533 | Bruce |
+----------------+-------+
*/


-- now finding the accomplise or whatever his partner is called

SELECT receiver, people.name FROM phone_calls
  JOIN people ON people.phone_number = phone_calls.receiver
 WHERE day = 28
   AND month = 7
   AND year = 2025
   AND duration < 60
   AND caller IN (
    SELECT phone_number
  FROM people
 WHERE license_plate IN (
    SELECT license_plate
      FROM people
     WHERE id IN (
        SELECT person_id FROM bank_accounts WHERE account_number IN (
            SELECT account_number
              FROM atm_transactions
             WHERE day = 28
               AND month = 7
               AND year = 2025
               AND atm_location = 'Leggett Street'
               AND transaction_type = 'withdraw'
        )
    )
) AND license_plate IN (
    SELECT license_plate
      FROM bakery_security_logs
     WHERE day = 28
       AND month = 7
       AND year = 2025
       AND hour = 10
       AND minute < 30
       AND minute > 15
) AND passport_number IN (
    SELECT passport_number
      FROM passengers
     WHERE flight_id = 36
)
);

/*
+----------------+-------+
|    receiver    | name  |
+----------------+-------+
| (375) 555-8161 | Robin |
+----------------+-------+
*/

-- I have reached the conclusion that Bruce with his partner Robin stole the cs50 duck and they escaped to New York City
