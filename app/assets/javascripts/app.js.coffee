@mod = angular.module 'KiddoMusic', [ 'ngResource' ]

@mod.controller 'MusicCtrl', [ '$scope', '$resource', ($scope, $resource) ->

        $scope.play = () ->
                alert( "Playing!!!" )
        
        ]
