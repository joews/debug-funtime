const http = require("http");
const connect = require("connect");

const PORT = 3000;

const app = connect();
app.use((req, res) => {
  res.end("wotcha");
});

http.createServer(app).listen(PORT, () => {
  console.log("started");
})



