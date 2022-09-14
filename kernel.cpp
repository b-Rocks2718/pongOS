extern "C" {
	void kernel_main() {
		// pointer to char at top left of screen
		char* video_memory = (char*)0xb8000;

		// Write an 'X' to video memory
		*video_memory = 'X';
	}
}