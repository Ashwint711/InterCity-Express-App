import mysql from "mysql2";
import dotenv from "dotenv";
import { query } from "express";
dotenv.config();

//pool is a collection of connection to the database
const pool1 = mysql
  .createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE,
  })
  .promise();

export async function getTrains() {
  const q =
    "select * from trains where train_no in (select distinct train_no from scheduled_for sf where train_no in (select train_no from travels_on where route_id in (select r1.route_id from (select  * from consists_of cs where station_code='PUNE' or station_code='CSMT') r1 inner join (select * from consists_of cs where station_code='PUNE' or station_code = 'CSMT' ) r2 where r1.route_id = r2.route_id and r1.station_code='PUNE' and r2.station_code='CSMT' and r1.position < r2.position)) and sf.date='2023-10-10')";
  const [row] = await pool1.query(q);
  return row;
}
