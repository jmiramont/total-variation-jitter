�� # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 #   T h e   f o l l o w i n g   s c r i p t   c o m p u t e s   t h e   r e l a t i v e   ( l o c a l )   j i t t e r   f o r   a l l   t h e 
#  f i l e s   i n s i d e   a   d i r e c t o r y .   T h e   c o m p u t e d   v a l u e s   a r e   s a v e d   i n   t e x t   f i l e   w i t h
#   t w o   c o l u m n s ,   o n e   f o r   t h e   f i l e   n a m e   a n d   t h e   o t h e r   f o r   t h e   j i t t e r   v a l u e . 
 # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
 e x t e n s i o n $ = " . w a v " 
 
 f o r m   J i t t e r 
 c o m m e n t   R u t a   d e   a c c e s o   a   l a   c a r p e t a 
 	 s e n t e n c e   r u t a _ a r c h i v o 
 c o m m e n t   E x t e n s i � n   ( E j e m p l o :   " . w a v " ) 
 	 s e n t e n c e   e x t e n s i o n   . w a v 
 e n d f o r m 
 
 s t r i n g s   =   C r e a t e   S t r i n g s   a s   f i l e   l i s t :   " l i s t " ,   r u t a _ a r c h i v o $   +   " / * "   +   e x t e n s i o n $ 
 n u m b e r O f F i l e s   =   G e t   n u m b e r   o f   s t r i n g s 
 f o r   i f i l e   t o   n u m b e r O f F i l e s 
         s e l e c t O b j e c t :   s t r i n g s 
         f i l e N a m e $   =   G e t   s t r i n g :   i f i l e 
         R e a d   f r o m   f i l e :   r u t a _ a r c h i v o $   +   " / "   +   f i l e N a m e $ 
 e n d f o r 
 
 
 f o r   i f i l e   t o   n u m b e r O f F i l e s 
 	 s e l e c t O b j e c t :   s t r i n g s 
 	 n o m b r e _ a r c h i v o $ =   n o p r o g r e s s   G e t   s t r i n g :   i f i l e 
 	 n o m b r e _ a r c h i v o _ s e $ = r e p l a c e _ r e g e x $   ( n o m b r e _ a r c h i v o $ ,   e x t e n s i o n $ ,   " " ,   1 ) 
 	 n o m b r e _ o b j e t o $ =   " S o u n d   " +   n o m b r e _ a r c h i v o _ s e $ 
                 n o m b r e _ p i t c h $ = " P i t c h   " +   n o m b r e _ a r c h i v o _ s e $ 
 	 
 	 #   S t d   n o r m a l i z a t i o n 
 	 #   s e l e c t O b j e c t :   n o m b r e _ o b j e t o $ 	 
 	 #   e s t a n d e v =   G e t   s t a n d a r d   d e v i a t i o n :   0 ,   0 ,   0 
 	 #   a p p e n d I n f o L i n e :   e s t a n d e v 
 	 #   M u l t i p l y :   1 / e s t a n d e v 
 	 
 	 # P i t c h   a n d   J i t t e r 
 	 s e l e c t O b j e c t :   n o m b r e _ o b j e t o $ 
 	 n o p r o g r e s s   T o   P i t c h   ( c c ) :   0 ,   6 0 ,   1 5 ,   " n o " ,   0 . 0 3 ,   0 . 4 5 ,   0 . 0 1 ,   0 . 3 5 ,   0 . 1 4 ,   6 0 0 
 	 s e l e c t O b j e c t :   n o m b r e _ o b j e t o $ 
 	 p l u s O b j e c t :   n o m b r e _ p i t c h $ 
 	 n o p r o g r e s s   T o   P o i n t P r o c e s s   ( c c ) 
 	 
 	 j i t a =   n o p r o g r e s s   G e t   j i t t e r   ( l o c a l ) :   0 ,   0 ,   0 . 0 0 0 1 ,   0 . 0 2 ,   1 . 3 
 	 j i t a = j i t a * 1 0 0 
 	 j i t a $ = f i x e d $   ( j i t a ,   2 ) 
 	 
 	 s a l i d a $   =   r u t a _ a r c h i v o $   +   " / j i t t e r _ P R A A T . t x t " 
 	 a p p e n d F i l e L i n e :   s a l i d a $ ,   n o m b r e _ a r c h i v o $ , "   " ,   j i t a $ 
 e n d f o r 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
