//Vincent Wilmet HW4
//vincent.wilmet@student-cs.fr

//init
db.getCollectionNames() 

//Q1
db.artistsnestedsongs.findOne() 

//Q2
db.artistsnestedsongs.find({"Link" : {$exists : true }}, {"Artist":true , "Genre":true})

//Q3
db.artistsnestedsongs.find({ "Artist": { $regex: "Stones", $options: "i" }}, {"Artist":true})


//Q4
db.artistsnestedsongs.find({ "Artist": { $regex: "Stones", $options: "i" }}, {"Artist":true}).size()

//Q5
db.artistsnestedsongs.find({ "Popularity": {$gt: 4} }, {"Artist": true})


//Q6
db.artistsnestedsongs.find({ "Popularity": {$eq: 0} }, {"Artist": true})

//Q7
db.artistsnestedsongs.find({"Songs": {$gt: {$size: 10}}}, {"Artist": true})


//Q8
db.artistsnestedsongs.find({"Songs": {$size: 0}}, {"Artist": true})


//Q9
db.artistsnestedsongs.distinct({"Songs": {$gt: {$size: 10}}}).find({"Artist": true})


//Q10
//no idea
db.artistsnestedsongs.find({},{"Genres": true, "Artist": true}).limit(40)


//Q11
//this list is specified by seperating each subgenre with a semicolon. 
//if we want to query this attribute we can use $regex or $match 


//Q12
db.artistsnestedsongs.find({"Genres": { $regex: "Folk", $options: "i" }}, {"Artist":true}).size()


//Q13
db.artistsnestedsongs.aggregate([
    {
        "$unwind" : "$Songs"
    },
    {
        "$group": 
        {
            "_id": {
                "Genre": "$Genre",
                "Language": "$Songs.Idiom"
            },
            "Number_of_Songs": {
                "$sum": NumberInt(1)
            }
        }
    },
    {
        "$project" : 
        {
            "Genre" : "$_id.Genre",
            "Language" : "$_id.Language",
            "Number_of_Songs" : true,
        }
    },
]);


