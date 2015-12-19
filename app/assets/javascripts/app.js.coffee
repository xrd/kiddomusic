@mod = angular.module 'KiddoMusic', [ 'ngResource' ]

@mod.controller 'MusicCtrl', [ '$scope', '$resource', ($scope, $resource) ->

        $scope.init_old_disabled = () ->
                playerInstance = jwplayer('player');
                # //jwplayer('container').pause(); // BAD! :(
                # playerInstance.pause(); # Good :)
                playerInstance.setup({
                        file: '/music/01.mp3'
                        height: 50,
                        width: 200,
                        fallback: false,
                          })
                $scope.player = playerInstance

        $scope.play = () ->
                player = $('#html5_player')[0]
                player.play()
                # $scope.html5_player.play()
                # $scope.player.play()
                $scope.playing = "Playin jdavey..."
                # alert( "Playing!!!" )
        
        ]
