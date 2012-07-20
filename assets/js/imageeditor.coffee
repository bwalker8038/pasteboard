(($) ->
	PasteBoard.ImageEditor = (() ->
		MAX_WIDTH_RATIO = 0.8
		MAX_HEIGHT_RATIO = 0.8

		image = null
		fileType = null
		$window = $(window)
		$imageEditor = $("<div>")
							.addClass("image-editor")

		$uploadButton = $("<button>")
							.addClass("button upload-button")
							.text("Upload")
							

		setPosition = () ->
			y = $window.height() / 2 - $imageEditor.outerHeight() / 2
			y = 0 if $imageEditor.outerHeight() > $window.height()
			$imageEditor.css(
				"top": y
			)

		setSize = () ->
			width = $(image).width()
			height = $(image).height()
			maxWidth = MAX_WIDTH_RATIO * $window.width()
			maxHeight = MAX_HEIGHT_RATIO * $window.height()

			width = Math.min maxWidth, width
			height = Math.min maxHeight, height

			$imageEditor
				.css(
					"width": width
					"height": height
					"overflow-x": if width is maxWidth then "scroll" else "hidden"
					"overflow-y": if height is maxHeight then "scroll" else "hidden"
				)

		uploadImage = () ->
			canvas = document.createElement("canvas")
			context = canvas.getContext("2d")

			canvas.width = image.width
			canvas.height = image.height

			context.drawImage image, 0, 0
			dataURL = if fileType then canvas.toDataURL(fileType) else canvas.toDataURL()
			PasteBoard.FileHandler.uploadFile dataURL
			$uploadButton.off "click"

		self = 
			init: (img, type) ->
				fileType ||= type
				this.loadImage img
				PasteBoard.DragAndDrop.hide()
				$(".splash").hide()
				
				$window.on "resize", () -> 
					setPosition()
					setSize()

				$uploadButton.on("click", uploadImage)

				
			loadImage: (img) ->
				image = new Image()
				image.src = img

				image.onload = () ->
					$imageEditor
						.append(image)
						.appendTo("body")

					setSize()
					setPosition()

					$uploadButton
						.appendTo("body")

	)() 
)(jQuery)