function MultiSelector( list_target, max ){

// Where to write the list
this.list_target = list_target;
// How many elements?
this.count = 0;
// How many elements?
this.id = 0;
// Is there a maximum?
if( max ){
this.max = max;
} else {
this.max = -1;
};

/**
 * Add a new file input element
 */
this.addElement = function( element,file_name ){

// Make sure it's a file input element
if( element.tagName == 'INPUT' && element.type == 'file' ){

// Element name -- what number am I?
//element.name = file_name + this.id++;
element.name = file_name ;

//alert(element.name);
// Add reference to this object
element.multi_selector = this;

// What to do when a file is selected
element.onchange = function(){

// New file input
var new_element = document.createElement( 'input' ); 
new_element.type = 'file';
new_element.size = 1;
new_element.className = "addfile";

//Get the name of upload file
var fileName = element.value.substring(element.value.lastIndexOf('\\')+1); 

//As a counter for recording the number of chinese characters
var counter = 0; 

for(var i =0 ;i<fileName.length;i++){
	if(fileName.charCodeAt(i)<27 || fileName.charCodeAt(i)>126){
		counter++;
	}
}

if(fileName.length+counter>70){
	alert("附件名称过长");
	
}

// Add new element
this.parentNode.insertBefore( new_element, this );

// Apply 'update' to element
this.multi_selector.addElement( new_element,file_name );

// Update list
this.multi_selector.addListRow( this );

// Hide this: we can't use display:none because Safari doesn't like it
this.style.position = 'absolute';
this.style.left = '-1000px';

};


// If we've reached maximum number, disable input element
if( this.max != -1 && this.count >= this.max ){
element.disabled = true;
};

// File element counter
this.count++;
// Most recent element
this.current_element = element;

} else {
// This can only be applied to file input elements!
alert( 'Error: not a file input element' );
};

};


/**
 * Add a new row to the list of files
 */
this.addListRow = function( element ){

// Row div
var new_row = document.createElement('div');


// Delete button
var new_row_button = document.createElement( 'input' );
new_row_button.type = 'button';
new_row_button.value = 'Delete';


// References
new_row.element = element;

// Delete function
new_row_button.onclick= function(){

// Remove element from form
this.parentNode.element.parentNode.removeChild( this.parentNode.element );

// Remove this row from the list
this.parentNode.parentNode.removeChild( this.parentNode );

// Decrement counter
this.parentNode.element.multi_selector.count--;

// Re-enable input element (if it's disabled)
this.parentNode.element.multi_selector.current_element.disabled = false;

// Appease Safari
//    without it Safari wants to reload the browser window
//    which nixes your already queued uploads
return false;
};

// Set row value
new_row.innerHTML = element.value;


// Add button
new_row.appendChild( new_row_button );

// Add it to the list
this.list_target.appendChild( new_row );

};

};