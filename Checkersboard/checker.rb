# Dynamic generate a checkersboard
# Structure as the following:
# Header: two paragraph in the top use to display players' names
# Body: a nxn square table (checkers broad)
  # => JS function interaction: click on empty square, checker appear;
  # => click on non-empty square, checker disapper
# Footer: two input box and one "start" button.
  # => when press the button, the text will display in the top of 2 paragraphs

#create the block with some contents
def create_block block_name,  contents="", id=nil, style=nil, extra={}
  result = []
  #check if any style is set
  if style == nil
    block_style = ""
  else
    block_style = " style=\"";
    style.each do |key, value|
      block_style += "#{key}:#{value}; "
    end
    block_style += "\""
  end

  #check if any id is set
  if id == nil
    block_id = ""
  else
    block_id = " id=\"" + id + "\""
  end

  #check if any extra attribute
  if extra == {}
    block_extra = ""
  else
    block_extra = ""
    extra.each do |key, value|
      block_extra += " #{key} = \"#{value}\""
    end
  end

  open_block = "<" + block_name + block_id + block_style + block_extra + ">"

  close_block = "</" + block_name + ">"

  result << open_block << contents << close_block
  result
end

# define a nxn square table in HTML to represent checkers board
def create_table num, length, onclick_method
  contents = []
  # outer loop define the row of the table
  for i in 0...num
    #set rows' height to the length
    contents.push "<tr style=\"height:#{length}px\">"
    for j in 0...num
      color = get_background_color i, j
      #set cols' width to length and the background color
      contents.push "<td style=\"width:#{length}px; background-color:#{color}\"
        onclick = \"#{onclick_method}\"></td>"
    end
    contents.push "</tr>"
  end
  contents
end

# get background color of the square
def get_background_color row, col
  #in even rows: every even col is white
  #in odd rows: every odd cols is white
  if (row % 2 == 0 && col % 2 == 0) || (row % 2 == 1 && col % 2 == 1)
    color = "white"
  else
    color = "black"
  end
  color
end

#insert javascript
def insert_js_function function_name, argument="", statements
  codes = []
  codes << "function " + function_name + "(#{argument}){"
  statements.each do |statement|
    codes << statement
  end
  codes << "}"
  codes
end


# first statment of HTML
puts "<!DOCTYPE html>"

#------------HTML-HEADER-----------------------------------------------
#define the html header

title = create_block("title", "CheckersBoard")
html_header = create_block("head", title)

#------------HTML-BODY-------------------------------------------------
#define the html body, include the structure and the javascript for interaction

#define players' names for display players name at the top
name_tag1 = create_block("p", "", "p1", \
  {"float" => "left", "color" => "red"})
name_tag2 = create_block("p", "", "p2", \
{"float" => "right", "color" => "blue"})

#combine name_tag1 and name_tag2 as header of html body
body_header = create_block("div", [name_tag1, name_tag2], "header", \
{"height" => "50px", "width" => "400px"})

#define table contents
table_contents = create_table 8, 50, "changeImage(this)"
#add to table block
table = create_block("table", table_contents, "checkersboard", \
  {"border"=> "1px solid black", "border-collapse"=> "collapse" })


#------------HTML-FOOTER----------------------------------------------
#define the html footer
#define inputbox for enter players' names
inputbox1 = create_block("input", "", "player1")
inputbox2 = create_block("input", "", "player2")
#define button "start"
js_function_name1 = "displayName()"
button_start = create_block("button", "Start", nil, nil, \
  {"onclick" => js_function_name1})
#combine these three elements as footer
footer = []
footer = create_block("div", [inputbox1, inputbox2, button_start], "footer")

#------------JAVASCRIPT------------------------------------------------
#define javascript use for interaction
#function changeImage() to add/remove checkers from a square
changeImage_statements = [
  "if(cel.style.backgroundColor === \"white\")",
  "src = \"checker_w.jpg\";",
  "else",
  "src = \"checker_b.jpg\";",
  "if(!cel.hasChildNodes()){",
  "var img = document.createElement(\"img\");",
  "img.src = src;",
  "cel.appendChild(img);",
  "}else",
  "cel.removeChild(cel.childNodes[0]);"
  ]
changeImage = insert_js_function "changeImage", "cel", changeImage_statements

#function displayName() to display name in the header
displayName_statements = [
  "p1 = document.getElementById(\"player1\");",
  "p2 = document.getElementById(\"player2\");",
  "name1 = document.getElementById(\"p1\");",
  "name2 = document.getElementById(\"p2\");",
  "name1.innerHTML = p1.value;",
  "name2.innerHTML = p2.value;"
]
displayName = insert_js_function "displayName", "", displayName_statements

js_contents = []
js_contents << changeImage << displayName

js = create_block("script", js_contents)

# combine the body
body_contents = []
body_contents << body_header << table << footer << js;
html_body = create_block("body", body_contents)


#combine every part of html
html = []
html << html_header << html_body

puts create_block("html", html)
