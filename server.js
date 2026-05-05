const express = require("express");
const fs = require("fs");
const path = require("path");
const cors = require("cors");
const yt = require("yt-dlp-exec");
const application = express();
const port = process.env.PORT || 5000;

application.use(cors());
application.use(express.text());
application.use(express.json());

application.use(express.static("public"));
application.use(express.urlencoded({
    extended: true }));



application.post("/download", async(req, res)=> {
    const url = req.body.url;

    try {
        
        //Make a temp folder
      await fs.mkdir("folder" , {recursive : true} , (error)=>{
            if(error){
                console.log(error) ;
                return ;
            }
        })
        
        const uniqueName = Date.now() ;
        const outputPath = path.join(__dirname, "folder", "%(title)s.%(ext)s");

        console.log("Downloading .... ");

        await yt(url, {
            output: outputPath,
            format: "bestvideo+bestaudio/best",
            mergeOutputFormat: "mp4",
            restrictFilenames: true,
        });
        
        const file = path.join(__dirname , "folder" , uniqueName) ;
       const files = fs.readdirSync(path.join(__dirname , "folder"))  ;
       
       const newFile = files[files.length - 1] ;
       
       const newFilePath = path.join(__dirname, "folder" , newFile ) ;
       
       res.download(newFilePath , (error)=>{
           console.log(error) ;
       })

    } catch (e) {
        console.error(e);
        return res.send(e);
    }
})

application.get("/" , (req , res)=>{
    res.send("Hello Server working") ;
})


application.listen(port, ()=> {
    console.log(`Server is running on port ${port}`);
})