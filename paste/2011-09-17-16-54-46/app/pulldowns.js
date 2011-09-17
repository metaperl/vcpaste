$(document).ready(function() {
    function dojson () {
	var json = null;
	my_url  = "/products.json";
	$.ajax({
	    'async': false,
	    'global': false,
	    'url': my_url,
	    'dataType': "json",
	    'success': function (data) {
		json = data;
	    }
	});
	return json;
    }

    function dictionary(list) {
	var map = {};
	for (var i = 0; i < list.length; ++i) {
	    var category = list[i].category;
	    if (!map[category]) 
		map[category] = [];
	    map[category].push(list[i]);    // add complete products
	}
	return map;
    }



    var productDict = dictionary(dojson());
    console.log(productDict);


    var categories = Object.keys(productDict);
    console.log('categories -- ' + categories);

    _.each(categories, function(category) {
	var co = "<option value=" + category + ">" + category + "</option>";
	console.log(co);
	$('#category').append($(co));

	dump(productDict[category]);
	_.each(productDict[category], function(p) {
	    console.log(p);
	    var po = "<option class=" + category + ">" + p.product + "</option>";
	    $('#product').append($(po));
	});

    });

    $("#product").chainedTo("#category");

});
