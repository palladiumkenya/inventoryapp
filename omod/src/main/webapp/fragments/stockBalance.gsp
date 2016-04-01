<script>
    var pDataString;
    jq(function(){
        var pData = getStockBalance();
        pDataString = JSON.stringify(pData);
        
		function StockListView(){
            var self = this;
            // Editable data
            self.stockItems = ko.observableArray([]);
            var mappedStockItems = jQuery.map(pData, function (item) {
                return item;
            });

            self.viewDetails = function(item){
                window.location.replace("viewCurrentStockBalanceDetail.page?drugId="+item.drug.id +"&formulationId="+item.formulation.id);

            }
            self.stockItems(mappedStockItems);
        }

        var list = new StockListView();
        ko.applyBindings(list, jq("#stocklist")[0]);
    });
	
    function getStockBalance() {
        var toReturn;
        jQuery.ajax({
            type: "GET",
            url: '${ui.actionLink("inventoryapp", "stockBalance", "fetchStockBalance")}',
            dataType: "json",
            global: false,
            async: false,
            success: function (data) {
                toReturn = data;
            }
        });
        return toReturn;
    }
</script>

<div class="dashboard clear">
	<div class="info-section">
		<div class="info-header">
			<i class="icon-folder-open"></i>

			<h3>VIEW DRUG STOCK</h3>
			
			<div>
				<i class="icon-filter" style="font-size: 26px!important; color: #5b57a6"></i>
				
				<label for="stockCategoryId">Category: </label>
				<select id="stockCategoryId" style="width: 200px;" name="categoryId">
					<option value="">ALL CATEGORIES</option>
                    <% listCategory.each { %>
						<option value="${it.id}" title="${it.name}">
							${it.name}
						</option>
                    <% } %>
				</select>
				
				<label for="stockDrugName">&nbsp; &nbsp;Name:</label>
				<input id="stockDrugName" type="text" value="" name="stockDrugName" placeholder=" Drug Name">
				
				<a class="button task" href="#">
					Search
				</a>
			</div>
			
			
		</div>
	</div>
</div>

<table id="stocklist">
    <thead>
		<th>#</th>
		<th>DRUG NAME</th>
		<th>CATEGORY</th>
		<th>FORMULATION</th>
		<th>QUANTITY</th>
		<th>RE-ORDER</th>
    </thead>
	
    <tbody data-bind="foreach: stockItems">
		<td data-bind="text: \$index() + 1"></td>
		<td>
			<a data-bind="html: drug.name,click:\$parent.viewDetails"></a>
		</td>
		
		<td data-bind="text: drug.category.name"></td>
		<td>
			<span data-bind="text: formulation.name"></span>: <span data-bind="text: formulation.dozage"></span>
		</td>
		
		<td data-bind="text: currentQuantity"></td>
		<td data-bind="text: drug.reorderQty"></td>
    </tbody>
</table>
