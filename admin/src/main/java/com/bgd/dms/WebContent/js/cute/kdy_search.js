
function cdt_init(){
	initSelCodes();
	
	if(cruConfig.cdtType=='form'){
		initFormCdt();
		return;
	}
	//×éºÏËÑË÷
	var cmp_fields = document.getElementsByName("cmp_field");
	var cmp_cdts = document.getElementsByName("cmp_cdt");
	var cmp_inputs = document.getElementsByName("cmp_input");	
	var cmp_sels = document.getElementsByName("cmp_sel");
	for(var i=0;i<cmp_fields.length;i++)
		init_query_row(cmp_fields[i],cmp_cdts[i],cmp_sels[i],cmp_inputs[i]);
}
