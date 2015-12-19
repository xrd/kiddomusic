@mod = angular.module 'KiddoMusic', [ 'ngResource' ]

@mod.controller 'MusicCtrl', [ '$scope', '$resource', ($scope, $resource) ->

        $scope.init = () ->
                playerInstance = jwplayer('player');
                # //jwplayer('container').pause(); // BAD! :(
                # playerInstance.pause(); # Good :)
                playerInstance.setup({
                        file: '/music/01.mp3'
                        height: 50,
                        width: 200
                          })
                $scope.player = playerInstance

        $scope.play = () ->
                $scope.player.play()
                # alert( "Playing!!!" )
        
        ]
