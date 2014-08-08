$(document).ready(function() {
  
  $("#theForm").submit(function(e){

    var formObj = $(this);
    var formData = new FormData(this); //html5 formdata
    var formURL = formObj.attr("action");
    
    //copy file control and replace with cleared value
    var fileInput = $("#fileInput");
    fileInput.val("").replaceWith ( fileInput = fileInput.clone(true));
    
    //remove error message
    if(document.getElementById("error")) {
      var parent = document.getElementById("submitPanel")
      var child = document.getElementById("error");
      parent.removeChild(child);
    }
    
    //create sent message if it does not exist
    if(!document.getElementById("submitted")) {
      var label = document.createElement("div");
      var t = document.createTextNode("Submitted");
      label.id = "submitted";
      label.className = "alert alert-success";
      label.appendChild(t);
      document.getElementById("submitPanel").appendChild(label);
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
        
        //remove submit message
        if(document.getElementById("submitted")) {
          var parent = document.getElementById("submitPanel")
          var child = document.getElementById("submitted");
          parent.removeChild(child);
        }
        //create error message
        var label = document.createElement("div");
        var t = document.createTextNode("Submission error");
        label.id = "error";
        label.className = "alert alert-warning";
        label.appendChild(t);
        document.getElementById("submitPanel").appendChild(label);
      }
    });

    e.preventDefault(); //prevent default action
    e.unbind();
  });
}); 
