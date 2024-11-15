import express from "express";

import { getUsers, getUser, createUser, getTrains } from "./database.js";

const app = express();

app.use(express.json());

app.get("/users", async (req, res) => {
  const users = await getUsers();
  res.send(users);
});

app.get("/users/:username/:password", async (req, res) => {
  const username = req.params.username;
  const password = req.params.password;
  const user = await getUser(username, password);
  res.send(user);
});

app.post("/users", async (req, res) => {
  const { username, email, password } = req.body;
  const user = await createUser(username, email, password);
  console.log(user);
  app.status(201).res.send(user);
});

app.post("/users/register", async (req, res) => {
  const { username, email, password } = req.body;
  const user = await createUser(username, email, password);
  console.log(user[0]);
  res.send(user[0]);
});

//Train Queries
app.get("/trains/:source/:destination/:date", async (req, res) => {
  const source = req.params.source;
  const destination = req.params.destination;
  const date = req.params.date;
  const trains = await getTrains(source, destination, date);
  res.send(trains);
});

/*app.post("/notes", async (req, res) => {
  const { title, contents } = req.body;
  const note = await createNote(title, contents);
  app.status(201).res.send(note);
}); */
//---------------------------------------------

// app.get("/notes", async (req, res) => {
//   const notes = await getNotes();
//   res.send(notes);
// });

// app.get("/notes/:id", async (req, res) => {
//   const id = req.params.id;
//   const note = await getNote(id);
//   res.send(note);
// });

// app.post("/notes", async (req, res) => {
//   const { title, contents } = req.body;
//   const note = await createNote(title, contents);
//   app.status(201).res.send(note);
// });

// app.use((err, req, res, next) => {
//   console.error(err.stack);
//   res.status(500).send("Something broke!");
// });

app.listen(8080, () => {
  console.log("Server is running on port 8080.");
});
