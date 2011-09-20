$( document ) . ready( function() {
    $( "#myform" )
	. validate(
	    {
		rules
		: {
		    password : "required",
		    password_again : { equalTo : "#password" }
		}
	    }
	);
} );
