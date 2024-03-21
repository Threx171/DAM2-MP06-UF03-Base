declare option output:method "xml";
declare option output:indent "yes";

<users>{
  for $user in distinct-values(doc("gaming.stackexchange/Posts.xml")//row/@OwnerDisplayName)
  let $questionCount := count(doc("gaming.stackexchange/Posts.xml")//row[@OwnerDisplayName = $user])
  order by $questionCount descending
  return
    <user>
      <name>{$user}</name>
      <questionCount>{$questionCount}</questionCount>
    </user>
}</users>
