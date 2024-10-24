---
layout: page
title: Search
---

<!-- HTML elements for search -->
<input type="text" id="search-input" placeholder="Search..." style="width:380px;height:2rem;border-radius: 5px;"/>
<ul id="results-container"></ul>

<!-- script pointing to jekyll-search.js -->
<script src="/js/simple-jekyll-search.min.js"></script>

<script>
SimpleJekyllSearch({
    searchInput: document.getElementById('search-input'),
    resultsContainer: document.getElementById('results-container'),
    json: '/search.json',
    searchResultTemplate: '<li><a href="{url}" title="{desc}">{title}</a></li>',
    noResultsText: 'Not Found',
    limit: 20,
    fuzzy: false
  })
</script>
