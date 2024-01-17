extends Node

# EDIT 14/01/2024: actually screw inheritance 
# i think composition makes more sense most of the time
# but i will leave this script here in case we ever 
# think inheritance will be a better design pattern for designing smth

# Interfaces: basically, we're gonna do some OOP principles

# any object with the following line of code:
# var implements = [Interface.HasHealth] 
# will need to implement all the functions that 
# the HasHealth class specifies

# basically it is inheriting from the HasHealth abstract class 
# with virtual functions and will need to implement those functions
# or we will throw a custom error message

# we can make an object implement multiple classes with:
# var implements = [Interface.HasHealth, Interface.OtherClass, ...]
# meaning that the object needs to implement ALL the functions from ALL the classes

######### abstract classes #########
class HasHealth:
	func takeDamage():
		pass
	
	func healHealth():
		pass
	
	func die():
		pass

class HasHitbox:
	func takeDamage():
		pass
	
	func healHealth():
		pass



######### my functions #########

# function to check if node has an interface
func interfaceIsImplemented(node, interface) -> bool:
	# node needs to implement the specified interface
	if "implements" in node && interface in node.implements:
		return true

	# otherwise node does not implemented specified interface
	return false

# track all scripts that have already been checked
var already_checked: Array[String]
# check if the input node implements the functions 
# it is supposed to implement
func checkNodeImplements(node): 
	# quick optimisation: 
	# no need to check a script that has already been checked
	var script_name = str(node.get_script())
	if script_name in already_checked:
		return

	# if the script of the node has var implements = Interface.blahblah
	if "implements" in node:
		
		# go through all classes that the node wants to implement
		for current_class in node.implements:
			
			# instantiate an instance of the abstract class 
			# that we are inheriting from
			# e.g. the HasHealth abstract class
			var instance = current_class.new()
			
			# go through all methods (functions) in this abstract class
			for method in instance.get_script().get_script_method_list():
				
				var error_msg: String = ("BRO Interface error: " + node.name 
				+ " does not have the " + method.name + " function.")
				
				# make sure this method is implemented by the node
				# assert(condition, "error_message") function will
				# throw an error during runtime if condition is false
				assert(method.name in node, error_msg)
	
	already_checked.append(script_name)

# check all initial nodes that were added in before _ready() is called
# this is just recursive DFS!!!
func checkInitialNodes(node):
	checkNodeImplements(node)
	
	for child in node.get_children():
		checkInitialNodes(child)



######### Godot functions #########

# this function will be called at the start to make sure all nodes 
# that inherit from an abstract class implements its virtual functions
func _ready():
	# check the initial nodes that exist before 
	# this function is called
	checkInitialNodes(get_tree().current_scene)

	# we are connecting the node_added signal 
	# (which emits whenever a node is added to the scene)
	# to our checkNodeImplements() function
	# so whenever this signal emits the function will be called
	get_tree().node_added.connect(checkNodeImplements)



