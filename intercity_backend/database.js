//Connection with database
import mysql from "mysql2";

import dotenv from "dotenv";
dotenv.config();

//pool is a collection of connection to the database
const pool = mysql
  .createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE,
  })
  .promise();

//Trains Queries
class rowData {
  constructor(row, flag) {
    this.row = row;
    this.flag = flag;
  }
}

export async function getTrains(source, destination, date) {
  const r1 = `(select * from consists_of cs where station_code='${source}' or station_code='${destination}')`;
  var res = await pool.query(r1);
  if (res[0].length > 0) {
    const r3 = `(select r1.route_id from ${r1} r1 inner join ${r1} r2 where r1.route_id = r2.route_id and r1.station_code='${source}' and r2.station_code='${destination}' and r1.position < r2.position)`;
    res = await pool.query(r3);
    if (res[0].length > 0) {
      const getTrainQuery = `select * from trains where train_no in (select distinct train_no from scheduled_for sf where train_no in (select train_no from travels_on where route_id in ${r3}) and sf.date='${date}')`;
      const [row] = await pool.query(getTrainQuery);
      var flag = row.length > 0 ? true : false;
      return new rowData(row, flag);
    }
  }
  return new rowData([], false);
}

//Users queries
export async function getUsers() {
  const [rows] = await pool.query("SELECT * FROM users");
  return rows;
}

//Vulnerable to sql injection
export async function getUser(username, password) {
  const query = "SELECT * FROM users WHERE username = ? AND password = ?";
  const [row] = await pool.query(
    query,
    [username, password],
    (error, results) => {},
    // "SELECT * FROM users WHERE username=${username} and password={password}",
    [username, password]
  );
  return row;
}

export async function createUser(username, email, password) {
  const [result] = await pool.query(
    "INSERT INTO users (username,email,password) VALUES (?, ?, ?)",
    [username, email, password]
  );
  const user = getUser(username, password);
  return user;
}

//------------------------------

// export async function getNotes() {
//   const [rows] = await pool.query("SELECT * FROM notes");
//   return rows;
// }

// export async function getNote(id) {
//   const [row] = await pool.query("SELECT * FROM notes WHERE id=?", [id]);
//   return row;
// }

// export async function createNote(title, contents) {
//   const [result] = await pool.query(
//     "INSERT INTO notes (title,contents) VALUES (?, ?)",
//     [title, contents]
//   );
//   const id = result.insertId;
//   return getNote(id);
// }

// export async function deleteNote(id) {
//   await pool.query("DELETE FROM notes WHERE id=?", [id]);
// }

// export async function updateNote(id, title, contents) {
//   const result = await pool.query(
//     "UPDATE notes SET title=?,contents=? WHERE id=?",
//     [title, contents, id]
//   );
//   return result;
// }

// const note = await updateNote(1, "A new note", "New content");
// console.log(note);
