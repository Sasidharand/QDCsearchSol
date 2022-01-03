<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ecommerce.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
        crossorigin="anonymous">
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"
        crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/azsearch.js@0.0.21/dist/AzSearch.css">
    <title>Azure Cognitive Search Demo App</title>
    <style>
        .searchResults__result h4 {
            margin-top: 0px;
            text-transform: initial;
        }

        .searchResults__result .resultDescription {
            margin: 0.5em 0 0 0;
        }
    </style>
</head>
<body>
    <div id="app">
        <nav class="navbar navbar-inverse navbar-fixed-top">
            <div class="container-fluid" style="background-color:deepskyblue">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#facetPanel" aria-expanded="false"
                        aria-controls="navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <div class="row" style="height:65px">
                        <div class="col-md-2 pagelabel" style="top:7px">
                            <img src="evolve.PNG" "/>
                        </div>
                        <div id="searchBox" class="col-mid-8 col-sm-8 col-xs-6" style="top:8px" ></div>
                        <div class="col-md-2 pagelabel" style="top:20px">QOIPR Catalog Search</div>
                        <div id="navbar" class="navbar-collapse collapse" style="top:8px">  </div>

                    </div>
                    </div>
            </div>
        </nav>
        <div class="container-fluid" >
            <div class="row" >
                <div id="facetPanel" class="col-sm-3 col-md-3 sidebar collapse" style="background-color:white">
                    <div id="clearFilters"></div>
                    <ul class="nav nav-sidebar">
                        <div className="panel panel-primary behclick-panel">
                            
                            <li>
                                <div id="ManufacturerFacet">
                                </div>
                            </li>
                            <li>
                                <div id="ProductLineFacet">
                                </div>
                            </li>
                            <li>
                                <div id="ModelFacet">
                                </div>
                            </li>
                        </div>
                    </ul>
                </div>
                <div class="col-sm-9 col-sm-offset-3 col-md-9 col-md-offset-3 results_section">
                    <div id="results" class="row placeholders">
                    </div>
                    <div id="pager" class="row">
                    </div>
                </div>
            </div>
        </div>
        <!-- Bootstrap core JavaScript
            ================================================== -->
        <!-- Placed at the end of the document so the pages load faster -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
</body>
<!-- Dependencies -->
<script src="https://cdn.jsdelivr.net/react/15.5.0/react.min.js"></script>
<script src="https://cdn.jsdelivr.net/react/15.5.0/react-dom.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/redux/3.6.0/redux.min.js"></script>
<!-- Main -->
<script src="https://cdn.jsdelivr.net/npm/azsearch.js@0.0.21/dist/AzSearch.bundle.js"></script>
<script>
    // WARNING
    // For demonstration purposes only, do not use in a production environment. For simplicity, this is a single HTML page that has the query key to the search service.
    // CORS (*) must be enabled in the index before using the demo app.

    // Initialize and connect to your search service
    var automagic = new AzSearch.Automagic({ index: "evolve-index", queryKey: "2FAC1447E6DA3A4751208C739FF977F0", service: "azureqoiprsearch" });

    const resultTemplate = `<div class="col-xs-12 col-sm-3 col-md-3 result_img" >
            <img class="img-responsive result_img" src={{ProdImage}} alt="image not found" />
        </div><div class="col-xs-12 col-sm-9 col-md-9"><h4>{{StdDescription}}</h4><div class="resultDescription"><a href="@search.text">{{{MfPN}}}</a></div></div>`;

    // add a results view using the template defined above
    automagic.addResults("results", { count: true }, resultTemplate);

    // Adds a pager control << 1 2 3 ... >>
    automagic.addPager("pager");

    // Set some processors to format results for display
    var suggestionsProcessor = function (results) {
        return results.map(function (result) {
            result.searchText = result["@search.text"];
            return result;
        });
    };

    automagic.store.setSuggestionsProcessor(suggestionsProcessor);

    var suggestionsTemplate = `
            <p> {{Category}} </p> {{{searchText}}}`;

    // Add a search box that uses suggester "evolve-suggest", grabbing some additional fields to display during suggestions. Use the template defined above
    automagic.addSearchBox("searchBox",
        {
            highlightPreTag: "<b>",
            highlightPostTag: "</b>",
            suggesterName: "evolve-suggest",
            select: "Category"
        },
        "",
        suggestionsTemplate);

    automagic.addCheckboxFacet("ManufacturerFacet", "Manufacturer", "string");
    automagic.addCheckboxFacet("ProductLineFacet", "ProductLine", "string");
    automagic.addCheckboxFacet("ModelFacet", "Model", "string");


    // Adds a button to clear any applied filters
    automagic.addClearFiltersButton("clearFilters");
</script>
<style>
</style>
</html>
