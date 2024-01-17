extends CharacterBody2D

class_name MyCharacterBody
# we will design all enemies with this custom class
# because CharacterBody2D doesnt support rotation velocity


# IMPORTANT: ANY NODE WITH A MOVEMENT COMPONENT 
# NEEDS THE rotation_speed VARIABLE
# this is like the velocity variable for CharacterBody2D and Rigidbody2D
var rotation_speed = 0

