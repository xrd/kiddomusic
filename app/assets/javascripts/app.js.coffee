@mod = angular.module 'KiddoMusic', [ 'ngResource' ]

# @mod.service 'FlickrRsrc', [ '$http', ( $http ) ->
#         load: () ->
#                 $http.get 'https://api.flickr.com/services/feeds/photos_public.gne'
#         ]

@mod.service 'MusicRsrc', [ '$resource', ($resource) ->
        $resource '/musics/:id/:action.json', {},
                {
                index: { method: "GET", isArray: true } 
                }
        ]

@mod.controller 'MusicCtrl', [ '$scope', 'MusicRsrc', '$http', ( $scope, MusicRsrc, $http ) ->

        $scope.loadSongs = () ->
                MusicRsrc.index {}, (response) ->
                        $scope.songs = response

        $scope.loadPictures = () ->
                $http(
                        url: '/musics/thumbnails'
                        # url: 'http://www.flickr.com/services/oembed/?url=http%3A//flickr.com/photos/bees/2362225867/&maxwidth=300&maxheight=400&jsoncallback=JSON_CALLBACK&format=json'
                        # url: 'http://api.flickr.com/services/feeds/photos_public.gne?jsoncallback=JSON_CALLBACK&format=json'
                        method: "GET"
                        ).success ( data, status, headers ) ->
                                $scope.pictures = data.d.results

        $scope.playing = false
        $scope.toggle = () ->
                $scope.playing = !$scope.playing
                unless $scope.playing
                        $scope.stop()
                else
                        $scope.play()

        $scope.getBgImage = (index) ->
                rv = {}
                mod_index = index % $scope.songs.length
                console.log "Mod index: #{mod_index}"
                if $scope.pictures and $scope.pictures[mod_index]
                        url = $scope.pictures[mod_index].Thumbnail.MediaUrl
                        console.log "URL: #{url}"
                        rv = { 'background-image' : 'url( ' + url + ')', 'background-repeat': 'no-repeat', 'background-size': 'cover' }
                rv

        $scope.init = () ->
                $scope.player = $('#html5_player')[0]
                $scope.loadSongs()
                $scope.loadPictures()
                

        $scope.stop = () ->
                $scope.player.pause()

        $scope.play = () ->
                $scope.player.play()
                # $scope.html5_player.play()
                # $scope.player.play()
                $scope.playing = "Playin jdavey..."
                # alert( "Playing!!!" )
        
        ]
