"
I'm the equivalent of the old HelpBrowser but written in Spec2.
I manage doc that are expressed as methods of certain classes but contrary to the old 
help browser I managed documentation written using Microdown.

```
SystemReference classAPIHelpBuilderClass: MicrodownClassAPIHelpBuilder.
SpHelpBrowserPresenter openOn: Point.
```

The browser can also manage the class comment written in Microdown. 

```
SystemReference classAPIHelpBuilderClass: MicrodownClassAPIHelpBuilder.
SpHelpBrowserPresenter openOn: SpListPresenter.
```
"
Class {
	#name : #SpHelpBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'loadedTopicList',
		'helpText',
		'textOutput',
		'syntaxHelper',
		'textInput',
		'helpTopicCache',
		'rootTopic'
	],
	#category : #'NewTools-NewHelpBrowser'
}
