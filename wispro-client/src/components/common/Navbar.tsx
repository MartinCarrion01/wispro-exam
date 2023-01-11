import {
  Box,
  Flex,
  HStack,
  IconButton,
  Button,
  Menu,
  MenuButton,
  MenuList,
  MenuItem,
  useDisclosure,
  Stack,
} from "@chakra-ui/react";
import { HamburgerIcon, CloseIcon, ChevronDownIcon } from "@chakra-ui/icons";
import NavLink from "./NavLink";
import { useSessionClient } from "../../store/ClientStore";
import SubTitle from "./Subtitle";
import { logout } from "../../services/ClientService";

const availableLinks = [
  { name: "Inicio", route: "/" },
  { name: "Planes", route: "/plans" },
  { name: "Mis solicitudes de contratación", route: "/subscription_requests" },
];

export default function Navbar() {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const client = useSessionClient();

  return (
    <>
      <Box bg={"teal.300"} px={4}>
        <Flex h={20} alignItems={"center"} justifyContent={"space-between"}>
          <IconButton
            size={"md"}
            icon={isOpen ? <CloseIcon /> : <HamburgerIcon />}
            aria-label={"Open Menu"}
            display={{ md: "none" }}
            onClick={isOpen ? onClose : onOpen}
          />
          <HStack spacing={8} alignItems={"center"}>
            <Box>
              <SubTitle text={"Wispro Client"} />
            </Box>
            <HStack
              as={"nav"}
              spacing={4}
              display={{ base: "none", md: "flex" }}
            >
              {availableLinks.map((link, index) => (
                <NavLink key={index} name={link.name} route={link.route} />
              ))}
            </HStack>
          </HStack>
          <Flex alignItems={"center"}>
            <Menu>
              <MenuButton as={Button} rightIcon={<ChevronDownIcon />}>
                {client ? `${client.first_name} ${client.last_name}` : ""}
              </MenuButton>
              <MenuList>
                <MenuItem onClick={logout}>Cerrar sesión</MenuItem>
              </MenuList>
            </Menu>
          </Flex>
        </Flex>

        {isOpen ? (
          <Box pb={4} display={{ md: "none" }}>
            <Stack as={"nav"} spacing={4}>
              {availableLinks.map((link, index) => (
                <NavLink key={index} name={link.name} route={link.route} />
              ))}
            </Stack>
          </Box>
        ) : null}
      </Box>
    </>
  );
}
