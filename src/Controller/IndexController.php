<?php

namespace App\Controller;

use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

/**
 *
 * Class IndexController.
 * @Route("/admin", name="admin_")
 */
class IndexController extends AbstractController
{
    /**
     * @var EntityManagerInterface
     */
    private EntityManagerInterface $em;

    public function __construct(EntityManagerInterface $em)
    {
        $this->em = $em;
    }

    /**
     * @Route("/")
     *
     * @return Response
     */
    public function index()
    {
        $products = $this->em->getRepository(Product::class)->findAll();

        return $this->render('index.html.twig', ['products' => $products]);
    }
}