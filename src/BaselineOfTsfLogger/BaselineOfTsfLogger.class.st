Class {
	#name : 'BaselineOfTsfLogger',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTsfLogger',
	#package : 'BaselineOfTsfLogger'
}

{ #category : 'baselines' }
BaselineOfTsfLogger >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec 
	]

]

{ #category : 'baselines - dependencies' }
BaselineOfTsfLogger >> defineDependencies: spec [





]

{ #category : 'baselines - groups' }
BaselineOfTsfLogger >> defineGroups: spec [

	spec 
		group: 'Core' with: #('TSF-Logger');
		group: 'Tests' with: #('TSF-Logger-Tests');
		group: 'default' with: #('Core' 'Tests').
		



]

{ #category : 'baselines - packages' }
BaselineOfTsfLogger >> definePackages: spec [

	spec 
		package: 'TSF-Logger';
		package: 'TSF-Logger-Tests' with: [ spec requires: #('TSF-Logger') ].

]
