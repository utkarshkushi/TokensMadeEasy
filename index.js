const express = require('express');
const path = require('path');
const app = express();
const mongoose = require('mongoose');
const Project = require('./models/project');
const bodyParser = require('body-parser');
require('dotenv').config();
const username = process.env.DB_USER_NAME;
const pass = process.env.DB_PASSWORD;

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({urlencoded: false}));

mongoose.connect(`mongodb+srv://${username}:${pass}@miniproject.vmme2h4.mongodb.net/?retryWrites=true&w=majority`)
.then(()=>{console.log("connected db")})
.catch(err => console.log(err));

app.use(express.static(path.join(__dirname, 'public')));


app.get('/main', async (req,res)=>{
    try {
      const projects = await Project.find().sort('-createdAt');
      res.render('home', { projects });
    } catch (error) {
      console.error(error);
      res.sendStatus(500);
    }
  })

app.get('/form', (req, res)=>{
    res.sendFile(path.join(__dirname , 'form.html'));
})

app.get('/searchMain', async (req, res)=>{
    
      try{
        const  query  = req.query.name;
        const projects = await Project.find({
            $or: [
              { name: { $regex: query, $options: 'i' } },
              { symbol: { $regex: query, $options: 'i' } },
              { web: { $regex: query, $options: 'i' } }
            ],
          });
          res.render('home', {projects});
      }
      catch (err) {
        console.error(err);
        res.status(500).send('Internal Server Error');
      }

})


app.get('/addProject', async (req,res)=>{
    let {address , name, symbol, tokensPerEth, initialMint, description, incentives, web,  link} = req.query;
    const incentivesArray = incentives.split(",");
    console.log('the tokens per eth is '+ tokensPerEth);
    try {
        const project = new Project({
            address,
            name,
            symbol,
            tokensPerEth,
            initialMint,
            description,
            incentives: incentivesArray,
            web,
            link
        });
        console.log(project);
        await project.save();
        res.redirect('/main');
      } catch (error) {
        console.error(error);
        res.render('error');
      }

})

app.get('/Projectpreview',async (req,res)=>{
    const id = req.query.projectId;
    const projects = await Project.find();
  const project = projects.find(p => p.id === id);
  res.render('projectPreview', { project });
})

app.listen(3021, ()=>{
    console.log('listening on port 3021');
})