map f l =
  if empty l then
    []
  else
    cons (f (head l)) (map f (tail l))
;
filter f l =
  if empty l then
    []
  else
    let x = head l
    in
      if f (head l) then cons (head l) xs else xs
;
foldr f init l =
  if emtpy l then
     init
  else
      foldr f (f init (head l)) (tail l)
;
last l =
  if empty (tail l) then
    head l
  else
    last (tail l)
;
concat l1 l2 =
  if empty l1 then
    l2
  else
    cons (head l1) (concat (tail l1) l2)
