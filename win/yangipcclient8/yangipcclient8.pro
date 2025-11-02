QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11


# Copyright (c) 2019-2022 yanggaofeng

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
#DEFINES += QT_WIN_MSC
HOME_BASE=../

win32{
    DEFINES += __WIN32__
    DEFINES +=_AMD64_

    INCLUDEPATH += $$HOME_BASE\include
    CONFIG(debug, debug|release) {
        LIBS += -L$$HOME_BASE/bin/app_win_debug
        DESTDIR += $$HOME_BASE/bin/app_win_debug
    }else{
        LIBS += -L$$HOME_BASE/bin/app_win_release
        DESTDIR += $$HOME_BASE/bin/app_win_release
    }
    LIBS += -lyangclient8

    msvc{
        QMAKE_CFLAGS += /utf-8
        QMAKE_CXXFLAGS += /utf-8
        QMAKE_LFLAGS    += /ignore:4099

    }

}
# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    mainwindow.cpp \
    video/yangrecordthread.cpp \
    yangplayer/YangPlayWidget.cpp


HEADERS += \
    mainwindow.h \
    video/yangrecordthread.h \
    yangplayer/YangPlayWidget.h


FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
