#Movie Recommendation

setwd("C:/Users/vsgui/Documents/RProjects/MovieRecommendation")
getwd()

install.packages("recommenderlab")
install.packages("ggplot2")
install.packages("data.table")
install.packages("reshape2")

library(recommenderlab)
library(ggplot2)
library(data.table)
library(reshape2)

movie_data <- read.csv("IMDB-Dataset/movies.csv", stringsAsFactors = FALSE)
rating_data <- read.csv("IMDB-Dataset/ratings.csv")

#Get the information about the data
str(movie_data)
summary(movie_data)
head(movie_data)

str(rating_data)
summary(rating_data)
head(rating_data)

?data.table

#DATA PRE-PROCESSING  
#Now we have to split the column Genres and transpose into a new Data Frame
#And give columns to each gender

#Individual Data Frame with 1 column with all genres
movie_genre <- as.data.frame(movie_data$genres, stringsAsFactors = FALSE)
View(movie_genre)

#New Data Frame with the genres organized
movie_genre2 <- as.data.frame(tstrsplit(movie_genre[,1], '[|]', 
                                        type.convert=TRUE), 
                              stringsAsFactors=FALSE) 
colnames(movie_genre2) <- c(1:10)
View(movie_genre2)

#Creating a new Table(Matrix) with with a column for each genre
list_genre <- c("Action", "Adventure", "Animation", "Children", 
                "Comedy", "Crime","Documentary", "Drama", "Fantasy",
                "Film-Noir", "Horror", "Musical", "Mystery","Romance",
                "Sci-Fi", "Thriller", "War", "Western")
genre_mat1 <- matrix(0,10330,18)
genre_mat1[1,] <- list_genre
colnames(genre_mat1) <- list_genre
View(genre_mat1)

#Populating the table using a for loop (Autor for this loop: DataFlair)
for (index in 1:nrow(movie_genre2)) {
  for (col in 1:ncol(movie_genre2)) {
    gen_col = which(genre_mat1[1,] == movie_genre2[index,col]) 
    genre_mat1[index+1,gen_col] <- 1
  }
}
#Now the new table is populated
View(genre_mat1)

#remove the first row, which was the genre list
genre_mat2 <-as.data.frame(genre_mat1[-1,], stringsAsFactors = FALSE)
View(genre_mat2)

#Last we have to convert from characters to integers, again we use a loop
for (col in 1:ncol(genre_mat2)) {
  genre_mat2[,col] <- as.integer(genre_mat2[,col])
}
str(genre_mat2)
summary(genre_mat2)

#Creating a searching matrix in order to find movies based on their genre
SearchMatrix <- cbind(movie_data[,1:2], genre_mat2[])
View(SearchMatrix)

#What can be perceived is that we have a sparse matrix (A Matrix in which most of the elements are zero)
#But we still have to convert the current Matrix(table) into a sparse matrix
#This is in order to make sense out of the ratings through recommenderlabs

#Convert to a sparse matrix
ratingMatrix <- dcast(rating_data, userId~movieId, value.var = "rating", na.rm=FALSE)
ratingMatrix <- as.matrix(ratingMatrix[,-1])
ratingMatrix <- as(ratingMatrix, "realRatingMatrix")
ratingMatrix

#Using the library recommendation lab to get some:
recommendation_model <- recommenderRegistry$get_entries(dataType = "realRatingMatrix")
names(recommendation_model)

#Understanding how is the library creating the recommendations:
lapply(recommendation_model, "[[", "description")

#As we can see the best model for what we are looking for is the IBCF or the UBCF("Recommender based on item-based collaborative filtering.")
recommendation_model$IBCF_realRatingMatrix$parameters

#K = Clustering
#Method : Cosine = Cosine similarity is a metric used to measure how similar the documents are irrespective of their size.
#Normalize : center = data preprocessing step where we adjust the scales of the features to have a standard scale of measure.(Center here)
#Alpha = Alpha is also known as the level of significance. This represents the probability of obtaining your results due to chance. 

#THIRD PART

#Recommending movies is dependent on creating a relationship of similarity between the two users. 

#Exploring way of finding similarities: Cosine, pearson, jaccard

#Similarities with the users by taking four users
#Each cell in the matrix represents the similarity that is shared bitween two users
similarity_mat <- similarity(ratingMatrix[1:4, ],
                             method = "cosine",
                             which = "users")
as.matrix(similarity_mat)

#Visualizing in a plot:
image(as.matrix(similarity_mat), main = "User's Similarities")

#Similarities with the movies: (Same idea)
movie_similarity <- similarity(ratingMatrix[, 1:4], 
                               method = "cosine",
                               which = "items")
as.matrix(movie_similarity)

#Visualizing in a plot:
image(as.matrix(movie_similarity), main = "Movies Similarity")

#Getting the most unique ratings: (The grades given to the movies by the users, 0 means there is no grade)
rating_values <- as.vector(ratingMatrix@data)
unique(rating_values)

#Now in a table: 
table_of_Ratings <- table(rating_values)
View(table_of_Ratings)

#FOURTH PART
#Visualizing the data so far:
View(genre_mat2)
View(SearchMatrix)
ratingMatrix

#Counting the number of views per movie
movie_views <- colCounts(ratingMatrix)

#Creating a Data Frame for the information above and organizing in descending order
table_views <- data.frame(movie = names(movie_views),
                          views = movie_views)
table_views <- table_views[order(table_views$views,
                           decreasing = TRUE), ]
View(table_views)

#Creating the column with the name of the movies since we only have the ID so far
table_views$title <- NA

#In order to populate the title column we are going to use another for loop
for (index in 1:10325){
  table_views[index, 3] <- as.character(subset(movie_data,
                                               movie_data$movieId ==
                                                 table_views[index, 1])$title)
}
table_views[1:6, ] #The first 6 movies
View(table_views)
tail(table_views)

#Plotting a bar plot with ggplot to see the number of views for the top movies than for the not so popular
ggplot(table_views[1:6, ], aes(x = title, y = views)) +
  geom_bar(stat="identity", fill ='darkgreen') +
  geom_text(aes(label = views), vjust=-0.3, size=3.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Total Views of the Top Films")

#Now the ones with few views (They only have one so nothing really interesting)
ggplot(tail(table_views), aes(x = title, y = views)) +
  geom_bar(stat="identity", fill ='brown') +
  geom_text(aes(label = views), vjust=-0.3, size=3.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Total Views of the bottom Films")


#Heatmap
