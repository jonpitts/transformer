$(document).ready(function() {
  
  $("#theForm").submit(function(e){

    var formObj = $(this);
    var formData = new FormData(this); //html5 formdata
    var formURL = formObj.attr("action");
    
    //copy file control and replace with cleared value
    var fileInput = $("#fileInput");
    fileInput.val("").replaceWith ( fileInput = fileInput.clone(true));
    
    //create sent message if it does not exist
    if(!document.getElementById("success")) {
      var label = document.createElement("span");
      var t = document.createTextNode("Submitted");
      label.id = "success"
      label.appendChild(t);
      document.getElementById("theForm").appendChild(label);
    }
    
    //ajax object to send
    $.ajax(
    {
      url: formURL,
      type: "POST",
      data: formData,
      mimeType: "multipart/form-data",
      contentType: false,
      cache: false,
      processData: false,
      success: function(responseTxt, textStatus, xhr)
      {
        alert(responseTxt);
        $("#collections").load("/ #collections");
        $("#errors").load("/ #errors");
      },
      error: function(jqXHR, textStatus, errorThrown)
      {
        alert("Error: "+errorThrown+": "+jqXHR.responseText);
      }
    });

    e.preventDefault(); //prevent default action
    e.unbind();
  });
}); 
