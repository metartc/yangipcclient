cmake_minimum_required(VERSION 3.16)
project(yangipcclient8 VERSION 1.0 LANGUAGES C CXX)

set(HOME_BASE_REL "../")
get_filename_component(HOME_BASE ${HOME_BASE_REL} REALPATH)

if(APPLE)
    set(MACOS 1)
endif()

set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Set up AUTOMOC and some sensible defaults for runtime execution
# When using Qt 6.3, you can replace the code block below with
# qt_standard_project_setup()
set(CMAKE_AUTOMOC ON)
include(GNUInstallDirs)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Gui)
find_package(Qt6 OPTIONAL_COMPONENTS Widgets)
find_package(Qt6 REQUIRED COMPONENTS Gui Network)
find_package(Qt6 REQUIRED COMPONENTS Gui OpenGLWidgets)

qt_add_executable(yangipcclient8 WIN32 MACOSX_BUNDLE
    main.cpp
    mainwindow.cpp mainwindow.h mainwindow.ui
    video/yangrecordthread.cpp video/yangrecordthread.h
    yangplayer/YangPlayWidget.cpp yangplayer/YangPlayWidget.h
)
target_compile_definitions(yangipcclient8 PRIVATE
    QT_DEPRECATED_WARNINGS
)

target_link_libraries(yangipcclient8 PRIVATE
    Qt::Core
    Qt::Gui
    Qt::Network
    Qt::OpenGLWidgets
)

if((QT_VERSION_MAJOR GREATER 4))
    target_link_libraries(yangipcclient8 PRIVATE
        Qt::Widgets
    )
endif()

if(MACOS)
    target_include_directories(yangipcclient8 PRIVATE
         ${CMAKE_SOURCE_DIR}/lib/yangclient8.framework/Headers
     )
    target_sources(yangipcclient8 PUBLIC
          video/yangrequest.h video/yangrequest.mm
      )

    target_link_directories(yangipcclient8 PRIVATE
        ${CMAKE_SOURCE_DIR}/lib
    )
    
  set_target_properties(yangipcclient8 PROPERTIES
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.in"
    )
    
    target_link_libraries(yangipcclient8 PRIVATE
        "-framework AVFoundation"
        "-framework CoreAudio"
        "-framework CoreMedia"
        "-framework CoreVideo"
        "-framework Network"
        "-F${CMAKE_SOURCE_DIR}/lib"
        "-framework yangclient8"

    )
endif()

if(CMAKE_BUILD_TYPE STREQUAL Debug AND MACOS)
    set_target_properties(yangipcclient8 PROPERTIES
         RUNTIME_OUTPUT_DIRECTORY "${HOME_BASE}/bin/app_debug"
    )
endif()

if(MACOS AND NOT CMAKE_BUILD_TYPE STREQUAL Debug)
    set_target_properties(yangipcclient8 PROPERTIES
         RUNTIME_OUTPUT_DIRECTORY "${HOME_BASE}/bin/app_release"
    )
endif()


install(TARGETS yangipcclient8
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Consider using qt_generate_deploy_app_script() for app deployment if
# the project can use Qt 6.3. In that case rerun qmake2cmake with
# --min-qt-version=6.3.
