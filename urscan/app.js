// app.js

jQuery(document).ready(function() {

	var apiUrl = 'http://www.ur-net.go.jp/kansai-akiya/xml_room/';

	$('.house').each(function (idx,house) {

		var id = $('.id', house).html();
		var reqUrl = apiUrl + id + '0.json';

		$.getJSON('http://whateverorigin.org/get?url=' 
					+ encodeURIComponent(reqUrl) + '&callback=?', 
			function(data){

				if (data.status.http_code === 200) {
					var json = eval("(" + data.contents + ")");

					json.ROOMS.forEach(function (apartment) {

						var roomUrl = 'http://www.ur-net.go.jp/kansai-akiya/hyogo/' 
										+ id + '0_room.html?JKSS=' + apartment.JKNO;

						$('ul', house).append('<li class="list-group-item text-success">' 
							+ '<span class="badge yoyaku-' + apartment.YOYAKU + '">' 
							+ apartment.ROOMTYPENM + '</span><span class="glyphicon glyphicon-thumbs-up"></span>' 
							+ '<a href="' + roomUrl + '" target="_blank"> '
							+ 'Apartment ' + apartment.ROOMNO + '</a>, '
							+ 'Size: ' + apartment.MEMSEKI + ', '
							+ 'Floor: ' + apartment.FLOOR + '/' + apartment.BHFLOOR + ', '
							+ 'Rent: ' + apartment.RENTGK + ' JPY</li>');  
					});
				}
				else {
					$('ul', house).append('<li class="list-group-item text-danger"><span class="glyphicon glyphicon-warning-sign"></span> No apartments available.</li>');  
				}
			}
		);

	});
});