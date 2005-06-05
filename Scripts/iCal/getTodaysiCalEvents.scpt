FasdUAS 1.101.10   ��   ��    k             l     �� ��    Q K	An applescript that shows today's events from iCal as growl notifications.       	  l     �� 
��   
 a [	The script shows how to register and use multiple types of notifications from Applescript:    	     l     ������  ��        l     �� ��     		"Today's Events"         l     �� ��     			and         l     �� ��    ! 		"In-Script Notifications"         l     �� ��    D >			are the two notification types that this script registers.          l     �� ��    @ : 			The types of notification are separated functionally.          l     �� ��    | v 			So the user can disable the first informational note from the prefpane without disabling the main notifications.            l     �� !��   ! t n--------------------------------------------------------------------------------------------------------------       " # " l     �� $��   $ t n--------------------------------------------------------------------------------------------------------------    #  % & % l     ������  ��   &  ' ( ' l     ������  ��   (  ) * ) l     ������  ��   *  + , + l     �� -��   - A ;	Register with growl and show the "gathering" notification.    ,  . / . l    2 0�� 0 O     2 1 2 1 k    1 3 3  4 5 4 l   ������  ��   5  6 7 6 O     8 9 8 k     : :  ; < ; r     = > = J     ? ?  @ A @ m    	 B B  Today's Events    A  C�� C m   	 
 D D  In-Script Notification   ��   > o      ����  0 myallnoteslist myAllNotesList <  E�� E I   ���� F
�� .registernull��� ��� null��   F �� G H
�� 
appl G m     I I - 'AppleScript iCal today's Event Notifier    H �� J K
�� 
anot J o    ����  0 myallnoteslist myAllNotesList K �� L M
�� 
dnot L o    ����  0 myallnoteslist myAllNotesList M �� N��
�� 
iapp N m     O O 
 iCal   ��  ��   9 m     P P2null     ߀�� L�GrowlHelperApp.appP��(���     ��   )       �P(�|����0�GRRR   alis    �  Macintosh HD               �g�H+   L�GrowlHelperApp.app                                              L��ȞV        ����  	                	Resources     �f��      �Ȃ6     L� L�  L�� D  D  YMacintosh HD:Library:PreferencePanes:Growl.prefPane:Contents:Resources:GrowlHelperApp.app   &  G r o w l H e l p e r A p p . a p p    M a c i n t o s h   H D  LLibrary/PreferencePanes/Growl.prefPane/Contents/Resources/GrowlHelperApp.app  / ��   7  Q R Q l   ������  ��   R  S�� S I   1���� T
�� .notifygrnull��� ��� null��   T �� U V
�� 
name U l 	   ! W�� W m     ! X X  In-Script Notification   ��   V �� Y Z
�� 
titl Y l 	 " # [�� [ m   " # \ \  Please Wait   ��   Z �� ] ^
�� 
desc ] l 	 & ) _�� _ m   & ) ` ` ^ XGathering today's events from iCal... (n.b. Events which are repeats will not be shown!)   ��   ^ �� a��
�� 
appl a m   * - b b - 'AppleScript iCal today's Event Notifier   ��  ��   2 m      P��   /  c d c l     ������  ��   d  e f e l  3 < g�� g r   3 < h i h I  3 8������
�� .misccurdldt    ��� null��  ��   i o      ���� 0 now  ��   f  j k j l  = L l�� l r   = L m n m \   = H o p o o   = @���� 0 now   p l  @ G q�� q n   @ G r s r 1   C G��
�� 
time s o   @ C���� 0 now  ��   n o      ���� 0 thismorning thisMorning��   k  t u t l  M T v�� v I  M T�� w��
�� .ascrcmnt****      � **** w l  M P x�� x o   M P���� 0 thismorning thisMorning��  ��  ��   u  y z y l  U d {�� { r   U d | } | \   U ` ~  ~ [   U ^ � � � o   U X���� 0 thismorning thisMorning � ]   X ] � � � m   X Y����  � 1   Y \��
�� 
days  m   ^ _����  } o      ���� 0 thisevening thisEvening��   z  � � � l  e l ��� � I  e l�� ���
�� .ascrcmnt****      � **** � l  e h ��� � o   e h���� 0 thisevening thisEvening��  ��  ��   �  � � � l     ������  ��   �  � � � l     �� ���   �  	Gather today's events    �  � � � l  m	 ��� � O   m	 � � � k   s � �  � � � l  s s������  ��   �  � � � r   s } � � � c   s y � � � J   s u����   � m   u x��
�� 
list � o      ���� 0 currentevents currentEvents �  � � � X   ~U ��� � � O   �P � � � k   �O � �  � � � l  � ��� ���   � Z T	Catch events that start today or that started before today, but have not yet ended.    �  ��� � X   �O ��� � � O   �J � � � k   �I � �  � � � I  � ��� ���
�� .ascrcmnt****      � **** � l  � � ��� � m   � � � �  CURRENT EVENT!   ��  ��   �  � � � r   �  � � � 1   � ���
�� 
wr1s � o      ���� 0 thestart theStart �  � � � r   � � � n   � � � 1  ��
�� 
tstr � o  ���� 0 thestart theStart � o      ���� 0 thestarttime theStartTime �  � � � r  / � � � c  + � � � K  ' � � �� � ��� 0 
eventtitle 
eventTitle � n   � � � 1  ��
�� 
wr11 � o  ���� 0 	thisevent 	thisEvent � �� � ��� $0 eventdescription eventDescription � n   � � � 1  ��
�� 
wr12 � o  ���� 0 	thisevent 	thisEvent � �� ����� 0 	starttime 	startTime � o   #���� 0 thestarttime theStartTime��   � m  '*��
�� 
reco � o      ���� 0 myrecord myRecord �  � � � r  0= � � � c  09 � � � J  05 � �  ��� � o  03���� 0 myrecord myRecord��   � m  58��
�� 
list � o      ���� 0 newlist newList �  ��� � r  >I � � � b  >E � � � o  >A���� 0 currentevents currentEvents � o  AD���� 0 newlist newList � o      ���� 0 currentevents currentEvents��   � o   � ����� 0 	thisevent 	thisEvent�� 0 	thisevent 	thisEvent � l  � � ��� � 6  � � � � � 2   � ���
�� 
wrev � l  � � ��� � G   � � � � � l  � � ��� � F   � � � � � @   � � � � � 1   � ���
�� 
wr1s � o   � ����� 0 thismorning thisMorning � B   � � � � � 1   � ���
�� 
wr1s � o   � ����� 0 thisevening thisEvening��   � l  � � ��� � F   � � � � � @   � � � � � 1   � ���
�� 
wr5s � o   � ��� 0 now   � B   � � � � � 1   � ��~
�~ 
wr1s � o   � ��}�} 0 thismorning thisMorning��  ��  ��  ��   � o   � ��|�| 0 thiscal thisCal�� 0 thiscal thisCal � 2   � ��{
�{ 
wres �  � � � l VV�z�y�z  �y   �  � � � l VV�x ��x   �  	Show the events.    �  � � � l VV�w�v�w  �v   �  � � � Z  V� � ��u�t � l Vc ��s � =  Vc � � � n  Va � � � m  ]a�r
�r 
nmbr � n V] � � � 2 Y]�q
�q 
cobj � o  VY�p�p 0 currentevents currentEvents � m  ab�o�o  �s   � O f� � � � l 	j� �n  I j��m�l
�m .notifygrnull��� ��� null�l   �k
�k 
name l 	lo�j m  lo  In-Script Notification   �j   �i
�i 
titl l 	ps�h m  ps		  No iCal events today   �h   �g

�g 
desc
 l 	vy�f m  vy  Go outside and play!   �f   �e�d
�e 
appl m  z} - 'AppleScript iCal today's Event Notifier   �d  �n   � m  fg P�u  �t   �  l ���c�b�c  �b    X  ��a k  �  Q  �� r  �� l ���` b  ��  b  ��!"! n  ��#$# o  ���_�_ 0 
eventtitle 
eventTitle$ o  ���^�^ "0 thiseventrecord thisEventRecord" m  ��%% 	  -      n  ��&'& o  ���]�] 0 	starttime 	startTime' o  ���\�\ "0 thiseventrecord thisEventRecord�`   o      �[�[ "0 theeventsummary theEventSummary R      �Z�Y�X
�Z .ascrerr ****      � ****�Y  �X   r  ��()( b  ��*+* m  ��,,  no summary -    + n  ��-.- o  ���W�W 0 	starttime 	startTime. o  ���V�V "0 thiseventrecord thisEventRecord) o      �U�U "0 theeventsummary theEventSummary /0/ l ���T�S�T  �S  0 121 Q  ��3453 r  ��676 n  ��898 o  ���R�R $0 eventdescription eventDescription9 o  ���Q�Q "0 thiseventrecord thisEventRecord7 o      �P�P *0 theeventdescription theEventDescription4 R      �O�N�M
�O .ascrerr ****      � ****�N  �M  5 r  ��:;: m  ��<<  no description   ; o      �L�L *0 theeventdescription theEventDescription2 =>= l ���K�J�K  �J  > ?�I? O �@A@ l 	� B�HB I � �G�FC
�G .notifygrnull��� ��� null�F  C �EDE
�E 
nameD l 	��F�DF m  ��GG  Today's Events   �D  E �CHI
�C 
titlH l 	��J�BJ o  ���A�A "0 theeventsummary theEventSummary�B  I �@KL
�@ 
descK l 	��M�?M o  ���>�> *0 theeventdescription theEventDescription�?  L �=N�<
�= 
applN m  ��OO - 'AppleScript iCal today's Event Notifier   �<  �H  A m  �� P�I  �a "0 thiseventrecord thisEventRecord o  ���;�; 0 currentevents currentEvents P�:P l �9�8�9  �8  �:   � m   m pQQ�null     ߀��  iiCal.app�����    �P<��(���    ��   )       �P(�|����0�wrbt   alis    D  Macintosh HD               �g�H+    iiCal.app                                                        ��?Y�        ����  	                Applications    �f��      �?K�      i  "Macintosh HD:Applications:iCal.app    i C a l . a p p    M a c i n t o s h   H D  Applications/iCal.app   / ��  ��   � RSR l     �7�6�7  �6  S T�5T l     �4�3�4  �3  �5       �2UV�2  U �1
�1 .aevtoappnull  �   � ****V �0W�/�.XY�-
�0 .aevtoappnull  �   � ****W k    	ZZ  .[[  e\\  j]]  t^^  y__  �``  ��,�,  �/  �.  X �+�*�)�+ 0 thiscal thisCal�* 0 	thisevent 	thisEvent�) "0 thiseventrecord thisEventRecordY A P B D�(�' I�&�%�$ O�#�"�! X�  \� ` b��������Q�������a�� �����
�	��������	%� ����,��<GO�(  0 myallnoteslist myAllNotesList
�' 
appl
�& 
anot
�% 
dnot
�$ 
iapp�# 
�" .registernull��� ��� null
�! 
name
�  
titl
� 
desc
� .notifygrnull��� ��� null
� .misccurdldt    ��� null� 0 now  
� 
time� 0 thismorning thisMorning
� .ascrcmnt****      � ****
� 
days� 0 thisevening thisEvening
� 
list� 0 currentevents currentEvents
� 
wres
� 
kocl
� 
cobj
� .corecnte****       ****
� 
wreva  
� 
wr1s
� 
wr5s� 0 thestart theStart
� 
tstr� 0 thestarttime theStartTime�
 0 
eventtitle 
eventTitle
�	 
wr11� $0 eventdescription eventDescription
� 
wr12� 0 	starttime 	startTime� 
� 
reco� 0 myrecord myRecord� 0 newlist newList
� 
nmbr�  "0 theeventsummary theEventSummary��  ��  �� *0 theeventdescription theEventDescription�-
� /� ��lvE�O*��������� UO*����a a �a � UO*j E` O_ _ a ,E` O_ j O_ k_  kE` O_ j Oa �jva &E` O �*a -[a a  l !kh  � � �*a "-a #[[[a $,\Z_ ;\[a $,\Z_ =A\[[a %,\Z_ ;\[a $,\Z_ =AB1[a a  l !kh � \a &j O*a $,E` 'O_ 'a (,E` )Oa *�a +,a ,�a -,a ._ )a /a 0&E` 1O_ 1kva &E` 2O_ _ 2%E` U[OY��U[OY�@O_ a  -a 3,j  !� *�a 4�a 5a a 6�a 7� UY hO ~_ [a a  l !kh  �a *,a 8%�a .,%E` 9W X : ;a <�a .,%E` 9O �a ,,E` =W X : ;a >E` =O� *�a ?�_ 9a _ =�a @� U[OY��OPU ascr  ��ޭ