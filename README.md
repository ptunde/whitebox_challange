# whitebox_challange

##My remarks

- I left the API key in the app/repo for your convinience, however I am aware that storing them in a repository is a really bad practice

- I did not find any API for pagination, ridiculisly large list of cryptocurrencies is loaded in one call and I tried my best to manage it.

- Because of the above issue I found using the filter API to be unnecessary because I already have all the details

- I've written a couple of Unit Tests, but did not cover the entire codebase because I considered it to be out of the scope of the exercise


##Used tech stack

- SwiftUI, MVVM, Combine, CoreData

- Third party library: Nuke for image loading & caching. I opted to use this library because SwiftUI's AsyncImage doesn't cache the images and I wanted to show my ability to add and use third party libraries 
