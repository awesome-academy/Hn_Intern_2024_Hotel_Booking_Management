$(document).on("turbo:load", function(){
  const availabelRoomsTable = document.querySelectorAll("#availabel_rooms_table tbody tr");
  const checkboxAll = document.querySelector("#check_box_all");

  if(availabelRoomsTable){
    availabelRoomsTable.forEach(row => {
      row.addEventListener("click", () => {
        toggleRowCheckbox(row);
      });

      const checkbox = row.querySelector("input[type='checkbox']");
      checkbox.addEventListener("click", () => {
        toggleRowCheckbox(row);
      });
    });
  }

  if(checkboxAll){
    checkboxAll.addEventListener("change", () => {
      availabelRoomsTable.forEach((row) => {
        const checkbox = row.querySelector("input[type='checkbox']");
        checkbox.checked = checkboxAll.checked;
      });
    });
  }
})

function toggleRowCheckbox(row){
  const checkbox = row.querySelector("input[type='checkbox']");
  checkbox.checked = !checkbox.checked;
  checkAll();
}

function checkAll(){
  const checkboxes = document.querySelectorAll(
    "#availabel_rooms_table tbody tr input[type='checkbox']"
  );
  const allCheck = Array.from(checkboxes).every((cb) => cb.checked);
  document.querySelector("#check_box_all").checked = allCheck;
}
