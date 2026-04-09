    //----------------------------------------------------------------------------#
	//  Plugin  to create many to many relation between two table using dragdrop  # 
	//  amr.tarek2013@gmail.com													  #
	//  4S web developer                                                           #
	//----------------------------------------------------------------------------#
	
	
	/////////////////////////////////////////////////////////////////////////////////#
	// Total Element In Array                                                        #
	/////////////////////////////////////////////////////////////////////////////////#
	    var item;
	    var totaleEl=0;
	/////////////////////////////////////////////////////////////////////////////////#
	// Array that will contain records which we need to create relation between them #
	/////////////////////////////////////////////////////////////////////////////////#
	
	    var ElementArray=new Array();
		 function addElement(el){
			 // add element to array of records
			    ElementArray.push(el);
				totaleEl++;
			  }
			 
	/////////////////////////////////////////////////////////////////////////////////#
	// Function To Remove record from array of  records                              #
	/////////////////////////////////////////////////////////////////////////////////#	 
		 function retrieverecord(el){
			 var found=-1;
			 for(var i=0;i<ElementArray.length;i++)
			     if(ElementArray[i][0]==el[0]&&ElementArray[i][1]==el[1])
				     found=i;   
			// Remove if found it	  	
				 if(found!=-1){			    
				 ElementArray.splice(found,1);
				 totaleEl--;
				 }
			 }
    /////////////////////////////////////////////////////////////////////////////////#
	// Function To Check if record -->(el) is exist in array of  records or not      #
	/////////////////////////////////////////////////////////////////////////////////#			 				 
			 function notexist(el){
				 
				 for(var i=0;i<ElementArray.length;i++)
					 if(el[0]==ElementArray[i][0]&&el[1]==ElementArray[i][1])
			         return false;
				     return true;
				 }
	/////////////////////////////////////////////////////////////////////////////////#
	// Function To Remove Item From Droppable Div                                    #
	/////////////////////////////////////////////////////////////////////////////////#			 
				  function remove(el) {
        
                  $(el).parent().parent().effect("highlight", {color: "#000000"}, 1000);
				  
				  var records=new Array(2);
				  records[0]=$(el).parent().parent().attr("id");
				  records[1]=$(el).attr("id");			  				
                  retrieverecord(records);
				  $(el).parent().animate({left: "-=200"}, 1000);
                  setTimeout(function() { $(el).parent().remove();
			      }, 500);
			  }

			
	/////////////////////////////////////////////////////////////////////////////////#
	// Function To Intialize Droppable and Draggable Div                             #
	/////////////////////////////////////////////////////////////////////////////////#	 
    $(document).ready(function() {		
		          
     //------------Intialize Draggable Div  -------------//
        $(".item_drag").draggable({revert: true,scroll: false});  
		
	//------------Intialize Droppable Div  -------------//
		
        $(".item_drop").droppable({
            accept: ".item_drag",
            activeClass: "",
            hoverClass: "",
            drop: function(event, ui) {
				item= ui.draggable.html();
                var itemid = ui.draggable.attr("id");
				var comm=$("textarea[id='"+itemid+"']").val();
				var h ='<div class="item_drag_drop" title="'+comm+'" id="'+itemid+'">'+item+'<span id="'+itemid+'" onclick="remove(this)" class="cancel"></span></div>';
                var element=new Array(3);
				element[0]=this.id;
				element[1]=itemid;
				element[2]=comm;	
				$("textarea[id='"+itemid+"']").val("");				
				if(notexist(element)){
					$('#dragid').val(itemid);
					$('#dropid').val(this.id);
					tryit();
				//$("#"+this.id).append(h);
				//$("#"+this.id).animate({top: "+=100"}, 100);
				//$("#"+this.id).parent().effect("highlight", {color: "#dfdfdf"}, 1000);
				//addElement(element);
				
						
				}
			
                
            }
        });
     
    });
	

	  
		//--------------------------------------

  