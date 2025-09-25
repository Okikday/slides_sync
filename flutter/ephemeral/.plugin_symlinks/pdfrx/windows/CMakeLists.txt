cmake_minimum_required(VERSION 3.10)

# Determine where the build placed the prebuilt PDFium
# BUILD_PDFIUM is expected under the binary directory used by the top-level CMake
set(BUILD_PDFIUM "\/pdfium")

set(ENCODED_PATH "\/chromium%2F7390")
set(DECODED_PATH "\/chromium/7390")

if(EXISTS "\")
  set(PDFIUM_PATH "\")
elseif(EXISTS "\")
  set(PDFIUM_PATH "\")
else()
  message(FATAL_ERROR "PDFium prebuilt not found at \ or \. Please download/extract the prebuilt PDFium for revision 7390 into \.")
endif()

# Copy entire bin and include directories into this plugin's binary dir so CMake can find them
file(COPY "\/bin" DESTINATION "\/pdfium")
file(COPY "\/include" DESTINATION "\/pdfium")
