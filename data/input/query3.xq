declare option output:method "xml";
declare option output:indent "yes";

<tags>{
  for $tag in distinct-values(doc("gaming.stackexchange/Posts.xml")//row/@Tags)
  let $tagList := tokenize(substring($tag, 2, string-length($tag) - 2), '><')
  for $individualTag in $tagList
  group by $individualTag
  let $tagCount := count($tagList)
  order by $tagCount descending
  return
    <tag>
      <name>{$individualTag}</name>
      <count>{$tagCount}</count>
    </tag>
}</tags>

