
from tinr2d2 import TinR2D2
import pygame

__author__ = 'stefan'


def robot_ctrl():

    robot_prev_state = None
    robot = TinR2D2("/dev/rfcomm3")

    robot_images = {
        robot.stop: pygame.image.load("assets/robot_aoff_boff.png"),
        robot.forward: pygame.image.load("assets/robot_afwd_bfwd.png"),
        robot.backward: pygame.image.load("assets/robot_abwd_bbwd.png"),
        robot.left: pygame.image.load("assets/robot_abwd_bfwd.png"),
        robot.right: pygame.image.load("assets/robot_afwd_bbwd.png")
    }

    robot_image_rect = robot_images[robot.stop].get_rect()
    robot_image_rect.left = 0

    pygame.init()

    size = [robot_image_rect.width, robot_image_rect.height]
    screen = pygame.display.set_mode(size)

    pygame.display.set_caption("Tin Drive")

    done = False
    clock = pygame.time.Clock()

    pygame.joystick.init()
    joystick_count = pygame.joystick.get_count()

    assert joystick_count > 0, "No Joystick found!"

    joystick = pygame.joystick.Joystick(0)
    joystick.init()

    assert joystick.get_name() in ["Sony PLAYSTATION(R)3 Controller", "Microsoft X-Box 360 pad"], \
        "Joystick 0 is not a PS3 or X-Box 360 controller (found '%s')" % joystick.get_name()

    is_ps3 = joystick.get_name() == "Sony PLAYSTATION(R)3 Controller"

    while not done:

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                done = True

        if is_ps3:

            button_up = joystick.get_button(4)
            button_down = joystick.get_button(6)
            button_left = joystick.get_button(7)
            button_right = joystick.get_button(5)

        else:

            hat_x, hat_y = joystick.get_hat(0)

            button_up = (hat_y == 1)
            button_down = (hat_y == -1)
            button_left = (hat_x == -1)
            button_right = (hat_x == 1)

        if button_up:
            robot_state = robot.forward
        elif button_down:
            robot_state = robot.backward
        elif button_left:
            robot_state = robot.left
        elif button_right:
            robot_state = robot.right
        else:
            robot_state = robot.stop

        if robot_state != robot_prev_state:
            robot_state()
            robot_prev_state = robot_state

        screen.blit(robot_images[robot_state], robot_image_rect)

        pygame.display.flip()
        clock.tick(20)

try:
    robot_ctrl()
except Exception as e:
    print(e)
