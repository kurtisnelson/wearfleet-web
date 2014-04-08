function Node(pusher, device, member){
    this._deviceChannel = pusher.subscribe('private-device_'+device);
    this._deviceChannel.bind('client-location', function(data) {
        setPosition(new google.maps.LatLng(data.latitude, data.longitude));
    });
    this._deviceChannel.bind('client-bearing', function(data) {
            setRotation(data.bearing);
    });
    this.setPosition = function(newPos) {
        this._position = newPos;
        this._marker.setPosition(this._position);
    }

    this.setRotation = function(rotation) {
        this._bearing = rotation;
        this.renderMarker();
    }

    this.renderMarker = function() {
        if(this._marker != null)
            this._marker.setMap(null);
        this._marker = new google.maps.Marker({
            title: this._id,
            map: map,
            position: this._position,
            icon: {
                path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
                scale: 5,
                rotation: this._bearing
            }
        });
        var infowindow = new google.maps.InfoWindow({
   			content: this._id
		});
        google.maps.event.addListener(this._marker, 'click', function(){
    		infowindow.open(map,this);
    	});
    }
    this.renderMarker();
}
