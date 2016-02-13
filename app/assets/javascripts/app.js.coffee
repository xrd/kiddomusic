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

        $scope.playing = undefined # false
        $scope.toggle = ( song ) ->
                $scope.playing = !$scope.playing
                unless $scope.playing
                        $scope.stop()
                else
                        $scope.play( song )

        $scope.getThumbnail = (index) ->
                # rv = {}
                url = undefined
                mod_index = index % $scope.songs.length
                console.log "Mod index: #{mod_index}"
                if $scope.pictures and $scope.pictures[mod_index]
                        url = $scope.pictures[mod_index].Thumbnail.MediaUrl
                        #console.log "URL: #{url}"
                        #rv = { 'background-image' : 'url( ' + url + ')', 'background-repeat': 'no-repeat', 'background-size': 'cover' }
                # rv
                url

        $scope.getBgImage = (song) ->
                rv = {}
                url = song.thumbnail
                rv = { 'background-image' : 'url( ' + url + ')', 'background-repeat': 'no-repeat', 'background-size': 'cover' }
                rv

        $scope.init = () ->
                $scope.player = $('#html5_player')[0]
                $scope.loadSongs()
                # $scope.loadPictures()
                

        $scope.stop = () ->
                $scope.player.pause()

        $scope.play = ( song ) ->
                d = new Date()
                currentTime = d.getTime()

                console.log "Current: #{currentTime} vs last #{$scope.lastClicked}"

                if currentTime < ( $scope.lastClicked + 2*1000 )
                        console.log "Ignoring it..."
                else
                        console.log "Time threshold exceeded, using this click"
                        if $scope.selected == song
                                $scope.stop()
                                $scope.playing = undefined
                        else
                                $scope.selected = song
                                $scope.player.src = song.src
                                $scope.player.play()
                                $scope.playing = "Playing #{song.title}"
                $scope.lastClicked = currentTime
        
        ]
