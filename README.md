# AmazingMovies
Coding challenge

This app is for iPhone iOS 13 only.

It is a simple iOS app with only 1 screen that shows a list of movies retrived from https://developers.themoviedb.org API.

The user is able to see popular movies in a collectionView with infinite scroll and save the favourites tapping on the white heart button.

Because of it is a Demo I used storyboards to speed up the design.

I used MVVM without coordinators because it is just 1 screen and I used Combine for bindings and network.

The download of the poster image starts only when the movie is showed and the image is saved on a NSCache, if the download fails it will retry next time that the movie will appear.

The API key is stored in the info.plist. I used quickType to generate automatically the codable and Network Link Conditioner to test the app with bad network.

The favourites are saved on a plist stored in the document directory, I prefered this to avoid the UserDefault limitations.

I used the Singleton pattern for the Network, Cache, and Favourites Plist  because of they could be usefull in future implementations of the app.

Since it is just a Demo I avoided to create a Mocked Network for the UnitTests and runned them on the true network layer.
