// 材料、数量フォーム追加
document.addEventListener("DOMContentLoaded", function() {
  document.getElementById("add-ingredient").addEventListener("click", function() {
    var content = document.getElementById("ingredient-fields-template").innerHTML;
    var uniqueId = new Date().getTime();
    content = content.replace(/_ingredients_attributes_Time.now.to_i_/g, "_ingredients_attributes_" + uniqueId + "_")
                     .replace(/ingredients_attributes_Time.now.to_i_/g, "ingredients_attributes_" + uniqueId + "_");
    document.getElementById("ingredients").insertAdjacentHTML('beforeend', content);
  });
});

document.addEventListener('DOMContentLoaded', () => {
  document.querySelector('#add-instruction').addEventListener('click', () => {
    let content = document.getElementById('recipe_step-fields-template').innerHTML;
    let uniqueId = new Date().getTime();
    content = content.replace(/_instructions_attributes_Time.now.to_i_/g, "_instructions_attributes_" + uniqueId + "_")
                     .replace(/instructions_attributes_Time.now.to_i_/g, "instructions_attributes_" + uniqueId + "_");
    document.getElementById('instructions').insertAdjacentHTML('beforeend', content);
  });
});


// 画像リアルタイム表示
$(document).on('turbolinks:load', function() {
  $('#imageField').on('change', function(e) {
    var file = e.target.files[0];
    var reader = new FileReader();

    reader.onload = function(e) {
      $('#imagePreviewImg').attr('src', e.target.result).show();
    };

    reader.readAsDataURL(file);
  });
});
