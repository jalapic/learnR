Customizing Fonts and Appearance
========================================================
author: AN Other
date: 25th October 2017
autosize: true
font-family: 'Helvetica'
font-import: 'https://fonts.googleapis.com/css?family=Lobster'
css: custom.css

Font family
========================================================
incremental: true

- e.g.add `font-family: 'Helvetica'` to YAML <br>
- The semantics of this are the same as for a CSS font-family (i.e. you can specify a comma separated list of alternate fonts)  <br>
- e.g. add `font-family: 'Helvetica', 'sans-serif', 'Arial'` to YAML  <br>


Font imports
========================================================

You can import fonts like this:

```
font-import: https://fonts.googleapis.com/css?family=Lobster
```


Smaller Text
========================================================

If you need smaller text for certain paragraphs, you can enclose text in the `<small>` tag. For example:  

<br>
<br>

<small>This sentence will appear smaller.</small>


Custom CSS
========================================================
By supplying a custom CSS style-sheet using `css: custom.css` you can pre-define all your own styles. You can  also add the CSS style guide at the top of the presentation code.





Applying Styles
===================================
class: illustration

You can apply classes defined in your CSS file to individual slides by adding a class field to the slide. For example this slide is `class: illustration`






Spans of text
================================== 
You can apply classes defined in your CSS file to spans of text by using a `<p>` or `<span>` tag. For example,

<p class="emphasized">Pay attention to this!</p>

<br>

<span class="emphasized">This is more subtle</span>`


Overstrikes
================================== 

Now the following text will be displayed red:

~~this text will be red~~

 

Custom  slide types
========================================
type: exclaim

There are default slide types of section, sub-section, prompt, and alert.  

But you can create your own default ones with CSS e.g. here's 'exclaim'.

