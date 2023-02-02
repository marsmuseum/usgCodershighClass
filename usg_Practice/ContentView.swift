//
//  ContentView.swift
//  usg_Practice
//
//  Created by kimjiyeon on 2023/01/30.
//

import SwiftUI

struct Movie: Codable ,Hashable{
    let title: String
    let image: String
}


struct MovieResponse: Codable{
    let data:[Movie]
    let message: String
}

/* struct Paging{
    let total : Int
    let skip: Int
    let limit: Int
}
*/

struct ContentView: View {
    @State var movies : [Movie] = []
    
    var body: some View {
        VStack{
            List(movies, id: \.self){item in
                    HStack{
                        AsyncImage(url: URL(string: "http://mynf.codershigh.com:8080"+item.image))
                        {
                            image in image.resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 100)
                        } placeholder: {
                            ProgressView()
                        }
                        Text(item.title)
                    }
                }
            Button {
                fetchMovieList()
            } label: {
                Text("Get Movie")
            }
        }.padding()

    }
    
    func fetchMovieList(){
        print("fetchMovieList")
        //1.URL
        let urlStr = "http://mynf.codershigh.com:8080/api/movies"
        let url = URL(string: urlStr)!
        
        //2.Request
        let request = URLRequest(url: url)
        
        //3.Session, Task
        URLSession.shared.dataTask(with: request) { data, response, error in
            do{
                let ret = try JSONDecoder().decode(MovieResponse.self, from: data!)
                //print("ret :", ret.data)
                for item in ret.data{
                    print(item.title)
                    print(item.image)
                    movies.append(item)
                }
            }
            catch{
                print("Error", error)
            }
        }.resume()
    
        }
    }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
